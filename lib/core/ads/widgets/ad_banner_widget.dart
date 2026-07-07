import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ad_ids.dart';
import '../ad_placement.dart';

class AdBannerWidget extends StatelessWidget {
  const AdBannerWidget({super.key, required this.placement});

  final AdPlacement placement;

  @override
  Widget build(BuildContext context) {
    if (!AdIds.isSupportedPlatform) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth.truncate()
                : MediaQuery.sizeOf(context).width.truncate();
        if (width <= 0) {
          return const SizedBox.shrink();
        }
        return _LoadedAdaptiveBanner(
          key: ValueKey('${placement.name}-$width'),
          placement: placement,
          width: width,
        );
      },
    );
  }
}

class _LoadedAdaptiveBanner extends StatefulWidget {
  const _LoadedAdaptiveBanner({
    super.key,
    required this.placement,
    required this.width,
  });

  final AdPlacement placement;
  final int width;

  @override
  State<_LoadedAdaptiveBanner> createState() => _LoadedAdaptiveBannerState();
}

class _LoadedAdaptiveBannerState extends State<_LoadedAdaptiveBanner> {
  BannerAd? _bannerAd;
  Widget? _adWidget;
  Timer? _retryTimer;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    try {
      final size =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            widget.width,
          );
      if (!mounted || size == null) {
        return;
      }

      final ad = BannerAd(
        adUnitId: AdIds.getAdUnitId(widget.placement),
        request: const AdRequest(),
        size: size,
        listener: BannerAdListener(
          onAdLoaded: (loadedAd) {
            if (!mounted) {
              loadedAd.dispose();
              return;
            }
            _retryTimer?.cancel();
            final bannerAd = loadedAd as BannerAd;
            setState(() {
              _bannerAd = bannerAd;
              _adWidget = AdWidget(key: UniqueKey(), ad: bannerAd);
            });
            _debugLog('Banner loaded: ${widget.placement.name}');
          },
          onAdFailedToLoad: (failedAd, error) {
            failedAd.dispose();
            _scheduleRetry();
            _debugLog('Banner failed: ${widget.placement.name}, error=$error');
          },
        ),
      );
      await ad.load();
    } catch (error) {
      _scheduleRetry();
      _debugLog('Banner failed: ${widget.placement.name}, error=$error');
    }
  }

  void _scheduleRetry() {
    if (!mounted || _bannerAd != null) {
      return;
    }

    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 30), () {
      if (mounted && _bannerAd == null) {
        unawaited(_loadAd());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    final adWidget = _adWidget;
    if (ad == null || adWidget == null) {
      return const SizedBox.shrink();
    }

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        width: ad.size.width.toDouble(),
        height: ad.size.height.toDouble(),
        child: adWidget,
      ),
    );
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
