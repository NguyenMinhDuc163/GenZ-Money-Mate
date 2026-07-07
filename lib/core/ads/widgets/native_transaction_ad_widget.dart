import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ad_ids.dart';
import '../ad_placement.dart';

class NativeTransactionAdWidget extends StatefulWidget {
  const NativeTransactionAdWidget({super.key});

  @override
  State<NativeTransactionAdWidget> createState() =>
      _NativeTransactionAdWidgetState();
}

class _NativeTransactionAdWidgetState extends State<NativeTransactionAdWidget> {
  NativeAd? _nativeAd;
  Widget? _adWidget;
  Timer? _retryTimer;
  bool _isLoaded = false;
  bool _didStartLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didStartLoading && AdIds.isSupportedPlatform) {
      _didStartLoading = true;
      _loadAd();
    }
  }

  void _loadAd() {
    final colorScheme = Theme.of(context).colorScheme;
    final ad = NativeAd(
      adUnitId: AdIds.getAdUnitId(AdPlacement.transactionListNative),
      request: const AdRequest(),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        mainBackgroundColor: colorScheme.surface,
        cornerRadius: 12,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurface,
          backgroundColor: colorScheme.surface,
          style: NativeTemplateFontStyle.bold,
          size: 14,
        ),
        secondaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurfaceVariant,
          backgroundColor: colorScheme.surface,
          size: 12,
        ),
        tertiaryTextStyle: NativeTemplateTextStyle(
          textColor: colorScheme.onSurfaceVariant,
          backgroundColor: colorScheme.surface,
          size: 12,
        ),
      ),
      listener: NativeAdListener(
        onAdLoaded: (loadedAd) {
          if (!mounted) {
            loadedAd.dispose();
            return;
          }
          _retryTimer?.cancel();
          final nativeAd = loadedAd as NativeAd;
          setState(() {
            _nativeAd = nativeAd;
            _adWidget = AdWidget(key: UniqueKey(), ad: nativeAd);
            _isLoaded = true;
          });
          _debugLog('Transaction native ad loaded');
        },
        onAdFailedToLoad: (failedAd, error) {
          failedAd.dispose();
          if (identical(_nativeAd, failedAd)) {
            _nativeAd = null;
          }
          _scheduleRetry();
          _debugLog('Transaction native ad failed: $error');
        },
      ),
    );
    _nativeAd = ad;
    unawaited(
      ad.load().catchError((Object error) {
        ad.dispose();
        if (identical(_nativeAd, ad)) {
          _nativeAd = null;
        }
        _scheduleRetry();
        _debugLog('Transaction native ad load threw: $error');
      }),
    );
  }

  void _scheduleRetry() {
    if (!mounted || _isLoaded) {
      return;
    }

    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 30), () {
      if (mounted && !_isLoaded) {
        _loadAd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final adWidget = _adWidget;
    if (!_isLoaded || adWidget == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: adWidget,
    );
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _nativeAd?.dispose();
    super.dispose();
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
