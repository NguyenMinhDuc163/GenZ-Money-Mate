import 'package:flutter/foundation.dart';

import 'ad_placement.dart';

class AdIds {
  const AdIds._();

  // App IDs are mirrored here for configuration checks. The native SDK reads
  // them from AndroidManifest.xml and Info.plist.
  static const String androidAppId = 'ca-app-pub-4649011658078977~3869351991';
  static const String iosAppId = 'ca-app-pub-4649011658078977~2861743260';

  static String getAdUnitId(AdPlacement placement) {
    if (!isSupportedPlatform) {
      throw UnsupportedError('AdMob is only supported on Android and iOS.');
    }

    if (kDebugMode) {
      return _testAdUnitId(placement);
    }

    return defaultTargetPlatform == TargetPlatform.android
        ? _androidAdUnitId(placement)
        : _iosAdUnitId(placement);
  }

  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static String _androidAdUnitId(AdPlacement placement) => switch (placement) {
    AdPlacement.home => 'ca-app-pub-4649011658078977/4074339892',
    AdPlacement.stats => 'ca-app-pub-4649011658078977/6351230432',
    AdPlacement.transactionSuccessInterstitial =>
      'ca-app-pub-4649011658078977/8785822083',
    AdPlacement.transactionListNative =>
      'ca-app-pub-4649011658078977/8751951502',
    AdPlacement.rankingRewarded => 'ca-app-pub-4649011658078977/2002710326',
  };

  static String _iosAdUnitId(AdPlacement placement) => switch (placement) {
    AdPlacement.home => 'ca-app-pub-4649011658078977/8402678705',
    AdPlacement.stats => 'ca-app-pub-4649011658078977/5843928581',
    AdPlacement.transactionSuccessInterstitial =>
      'ca-app-pub-4649011658078977/4463433696',
    AdPlacement.transactionListNative =>
      'ca-app-pub-4649011658078977/1065033177',
    AdPlacement.rankingRewarded => 'ca-app-pub-4649011658078977/1728589608',
  };

  static String _testAdUnitId(AdPlacement placement) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return switch (placement) {
      AdPlacement.home || AdPlacement.stats =>
        isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716',
      AdPlacement.transactionSuccessInterstitial =>
        isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',
      AdPlacement.transactionListNative =>
        isAndroid
            ? 'ca-app-pub-3940256099942544/2247696110'
            : 'ca-app-pub-3940256099942544/3986624511',
      AdPlacement.rankingRewarded =>
        isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313',
    };
  }
}
