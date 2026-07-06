import 'package:flutter_test/flutter_test.dart';
import 'package:genz_money_mate/core/ads/ad_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DateTime now;
  late SharedPreferences preferences;
  late InterstitialFrequencyCap frequencyCap;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    preferences = await SharedPreferences.getInstance();
    now = DateTime(2026, 7, 6, 12);
    frequencyCap = InterstitialFrequencyCap(
      sharedPreferences: preferences,
      now: () => now,
    );
  });

  test('requires four successful saves and a ready ad', () async {
    for (var index = 0; index < 3; index++) {
      await frequencyCap.recordSuccess();
    }

    expect(frequencyCap.canShow(isAdReady: true), isFalse);

    await frequencyCap.recordSuccess();
    expect(frequencyCap.canShow(isAdReady: false), isFalse);
    expect(frequencyCap.canShow(isAdReady: true), isTrue);
  });

  test('markShown resets count and starts the cooldown', () async {
    for (var index = 0; index < 4; index++) {
      await frequencyCap.recordSuccess();
    }
    await frequencyCap.markShown();

    expect(frequencyCap.successCount, 0);

    for (var index = 0; index < 4; index++) {
      await frequencyCap.recordSuccess();
    }
    expect(frequencyCap.canShow(isAdReady: true), isFalse);

    now = now.add(const Duration(minutes: 3));
    expect(frequencyCap.canShow(isAdReady: true), isTrue);
  });

  test('a failed display does not consume the accumulated count', () async {
    for (var index = 0; index < 4; index++) {
      await frequencyCap.recordSuccess();
    }

    expect(frequencyCap.canShow(isAdReady: true), isTrue);
    expect(frequencyCap.successCount, 4);
  });
}
