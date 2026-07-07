import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_ids.dart';
import 'ad_placement.dart';

class InterstitialFrequencyCap {
  InterstitialFrequencyCap({
    required SharedPreferences sharedPreferences,
    DateTime Function()? now,
    this.successThreshold = 4,
    this.cooldown = const Duration(minutes: 3),
  }) : _sharedPreferences = sharedPreferences,
       _now = now ?? DateTime.now;

  static const successCountKey = 'ad_interstitial_success_transaction_count';
  static const lastShownAtKey = 'ad_last_interstitial_shown_at';
  final SharedPreferences _sharedPreferences;
  final DateTime Function() _now;
  final int successThreshold;
  final Duration cooldown;

  int get successCount => _sharedPreferences.getInt(successCountKey) ?? 0;

  Future<int> recordSuccess() async {
    final nextCount = successCount + 1;
    await _sharedPreferences.setInt(successCountKey, nextCount);
    return nextCount;
  }

  bool canShow({required bool isAdReady}) {
    if (!isAdReady || successCount < successThreshold) {
      return false;
    }

    final lastShownAtMillis = _sharedPreferences.getInt(lastShownAtKey);
    if (lastShownAtMillis == null) {
      return true;
    }

    final lastShownAt = DateTime.fromMillisecondsSinceEpoch(lastShownAtMillis);
    return _now().difference(lastShownAt) >= cooldown;
  }

  Future<void> markShown() async {
    await Future.wait([
      _sharedPreferences.setInt(successCountKey, 0),
      _sharedPreferences.setInt(lastShownAtKey, _now().millisecondsSinceEpoch),
    ]);
  }
}

class AdService {
  AdService({
    required SharedPreferences sharedPreferences,
    DateTime Function()? now,
  }) : _frequencyCap = InterstitialFrequencyCap(
         sharedPreferences: sharedPreferences,
         now: now,
       );

  final InterstitialFrequencyCap _frequencyCap;

  InterstitialAd? _transactionSuccessInterstitial;
  RewardedAd? _rankingRewardedAd;
  final ValueNotifier<bool> _rankingRewardedReady = ValueNotifier(false);
  bool _isInitialized = false;
  bool _isLoadingInterstitial = false;
  bool _isLoadingRankingRewarded = false;
  bool _isShowingInterstitial = false;
  bool _isDisposed = false;
  Future<void>? _initializeFuture;
  Timer? _interstitialRetryTimer;
  Timer? _rankingRewardedRetryTimer;
  Future<void> _saveSequence = Future<void>.value();

  ValueListenable<bool> get rankingRewardedReady => _rankingRewardedReady;

  Future<void> initialize() {
    if (!AdIds.isSupportedPlatform || _isInitialized || _isDisposed) {
      return Future<void>.value();
    }

    return _initializeFuture ??= _initialize();
  }

  Future<void> _initialize() async {
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      _debugLog('AdMob initialized');
      unawaited(preloadTransactionSuccessInterstitial());
      unawaited(preloadRankingRewarded());
    } catch (error) {
      _debugLog('AdMob initialization failed: $error');
    } finally {
      if (!_isInitialized) {
        _initializeFuture = null;
      }
    }
  }

  Future<void> preloadRankingRewarded() async {
    if (!_isInitialized ||
        _isDisposed ||
        _isLoadingRankingRewarded ||
        _rankingRewardedAd != null ||
        _rankingRewardedReady.value) {
      if (!_isInitialized && !_isDisposed) {
        unawaited(initialize());
      }
      return;
    }

    _rankingRewardedRetryTimer?.cancel();
    _isLoadingRankingRewarded = true;
    try {
      await RewardedAd.load(
        adUnitId: AdIds.getAdUnitId(AdPlacement.rankingRewarded),
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            _isLoadingRankingRewarded = false;
            if (_isDisposed) {
              ad.dispose();
              return;
            }
            _rankingRewardedAd = ad;
            _rankingRewardedReady.value = true;
            _debugLog('Ranking rewarded loaded');
          },
          onAdFailedToLoad: (error) {
            _isLoadingRankingRewarded = false;
            if (!_isDisposed) {
              _rankingRewardedReady.value = false;
              _scheduleRankingRewardedRetry();
            }
            _debugLog('Ranking rewarded failed to load: $error');
          },
        ),
      );
    } catch (error) {
      _isLoadingRankingRewarded = false;
      if (!_isDisposed) {
        _rankingRewardedReady.value = false;
        _scheduleRankingRewardedRetry();
      }
      _debugLog('Ranking rewarded load threw: $error');
    }
  }

  Future<bool> showRankingRewarded({
    required VoidCallback onRewardEarned,
  }) async {
    final ad = _rankingRewardedAd;
    if (_isDisposed || ad == null) {
      _debugLog('Ranking rewarded skipped: not ready');
      if (!_isInitialized) {
        unawaited(initialize());
      }
      unawaited(preloadRankingRewarded());
      return false;
    }

    _rankingRewardedAd = null;
    _rankingRewardedReady.value = false;
    var rewardDelivered = false;
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdShowedFullScreenContent: (_) {
        _debugLog('Ranking rewarded shown');
      },
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        _debugLog('Ranking rewarded dismissed: earned=$rewardDelivered');
        unawaited(preloadRankingRewarded());
      },
      onAdFailedToShowFullScreenContent: (failedAd, error) {
        failedAd.dispose();
        _debugLog('Ranking rewarded failed to show: $error');
        unawaited(preloadRankingRewarded());
      },
    );

    try {
      await ad.show(
        onUserEarnedReward: (_, reward) {
          if (rewardDelivered) {
            return;
          }
          rewardDelivered = true;
          _debugLog('Ranking reward earned: ${reward.amount} ${reward.type}');
          onRewardEarned();
        },
      );
      return true;
    } catch (error) {
      ad.dispose();
      _debugLog('Ranking rewarded show threw: $error');
      unawaited(preloadRankingRewarded());
      return false;
    }
  }

  Future<void> preloadTransactionSuccessInterstitial() async {
    if (!_isInitialized ||
        _isDisposed ||
        _isLoadingInterstitial ||
        _isShowingInterstitial ||
        _transactionSuccessInterstitial != null) {
      if (!_isInitialized && !_isDisposed) {
        unawaited(initialize());
      }
      return;
    }

    _interstitialRetryTimer?.cancel();
    _isLoadingInterstitial = true;
    try {
      await InterstitialAd.load(
        adUnitId: AdIds.getAdUnitId(AdPlacement.transactionSuccessInterstitial),
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _isLoadingInterstitial = false;
            if (_isDisposed) {
              ad.dispose();
              return;
            }
            _transactionSuccessInterstitial = ad;
            _debugLog('Interstitial loaded');
          },
          onAdFailedToLoad: (error) {
            _isLoadingInterstitial = false;
            _scheduleInterstitialRetry();
            _debugLog('Interstitial failed to load: $error');
          },
        ),
      );
    } catch (error) {
      _isLoadingInterstitial = false;
      _scheduleInterstitialRetry();
      _debugLog('Interstitial load threw: $error');
    }
  }

  void _scheduleInterstitialRetry() {
    if (_isDisposed ||
        !_isInitialized ||
        _transactionSuccessInterstitial != null) {
      return;
    }

    _interstitialRetryTimer?.cancel();
    _interstitialRetryTimer = Timer(const Duration(seconds: 30), () {
      unawaited(preloadTransactionSuccessInterstitial());
    });
  }

  void _scheduleRankingRewardedRetry() {
    if (_isDisposed ||
        !_isInitialized ||
        _rankingRewardedAd != null ||
        _rankingRewardedReady.value) {
      return;
    }

    _rankingRewardedRetryTimer?.cancel();
    _rankingRewardedRetryTimer = Timer(const Duration(seconds: 30), () {
      unawaited(preloadRankingRewarded());
    });
  }

  Future<void> onTransactionSavedSuccessfully() {
    _saveSequence = _saveSequence
        .catchError((Object _) {})
        .then((_) => _handleTransactionSavedSuccessfully());
    return _saveSequence;
  }

  Future<bool> canShowTransactionSuccessInterstitial() async {
    return !_isShowingInterstitial &&
        _frequencyCap.canShow(
          isAdReady: _transactionSuccessInterstitial != null,
        );
  }

  Future<void> _handleTransactionSavedSuccessfully() async {
    if (_isDisposed || !AdIds.isSupportedPlatform) {
      return;
    }

    final count = await _frequencyCap.recordSuccess();
    if (!await canShowTransactionSuccessInterstitial()) {
      _debugLog(
        'Interstitial skipped: count=$count, ready=${_transactionSuccessInterstitial != null}',
      );
      if (_transactionSuccessInterstitial == null) {
        unawaited(preloadTransactionSuccessInterstitial());
      }
      return;
    }

    await _showTransactionSuccessInterstitial();
  }

  Future<bool> _showTransactionSuccessInterstitial() async {
    final ad = _transactionSuccessInterstitial;
    if (ad == null || _isShowingInterstitial) {
      return false;
    }

    _transactionSuccessInterstitial = null;
    _isShowingInterstitial = true;
    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (_) {
        _debugLog('Interstitial shown');
        unawaited(_frequencyCap.markShown());
      },
      onAdDismissedFullScreenContent: (shownAd) {
        shownAd.dispose();
        _isShowingInterstitial = false;
        unawaited(preloadTransactionSuccessInterstitial());
      },
      onAdFailedToShowFullScreenContent: (failedAd, error) {
        failedAd.dispose();
        _isShowingInterstitial = false;
        _debugLog('Interstitial failed to show: $error');
        unawaited(preloadTransactionSuccessInterstitial());
      },
    );

    try {
      await ad.show();
      return true;
    } catch (error) {
      ad.dispose();
      _isShowingInterstitial = false;
      _debugLog('Interstitial show threw: $error');
      unawaited(preloadTransactionSuccessInterstitial());
      return false;
    }
  }

  void dispose() {
    if (_isDisposed) {
      return;
    }
    _isDisposed = true;
    _interstitialRetryTimer?.cancel();
    _rankingRewardedRetryTimer?.cancel();
    _transactionSuccessInterstitial?.dispose();
    _transactionSuccessInterstitial = null;
    _rankingRewardedAd?.dispose();
    _rankingRewardedAd = null;
    _rankingRewardedReady.dispose();
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
