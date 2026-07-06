import 'package:flutter_test/flutter_test.dart';
import 'package:genz_money_mate/core/ads/native_ad_placement_policy.dart';

void main() {
  test('does not insert native ads before eight transactions', () {
    expect(
      NativeAdPlacementPolicy.shouldInsertAfter(
        displayedTransactionCount: 5,
        totalTransactionCount: 7,
      ),
      isFalse,
    );
  });

  test('inserts after each group of eight displayed transactions', () {
    expect(
      NativeAdPlacementPolicy.shouldInsertAfter(
        displayedTransactionCount: 8,
        totalTransactionCount: 20,
      ),
      isTrue,
    );
    expect(
      NativeAdPlacementPolicy.shouldInsertAfter(
        displayedTransactionCount: 12,
        totalTransactionCount: 20,
      ),
      isFalse,
    );
    expect(
      NativeAdPlacementPolicy.shouldInsertAfter(
        displayedTransactionCount: 16,
        totalTransactionCount: 20,
      ),
      isTrue,
    );
  });
}
