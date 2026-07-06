class NativeAdPlacementPolicy {
  const NativeAdPlacementPolicy._();

  static const int interval = 8;

  static bool shouldInsertAfter({
    required int displayedTransactionCount,
    required int totalTransactionCount,
  }) {
    return totalTransactionCount >= interval &&
        displayedTransactionCount > 0 &&
        displayedTransactionCount % interval == 0;
  }
}
