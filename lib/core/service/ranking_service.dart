import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ranking_model.dart';
import '../models/transaction_model.dart';
import '../models/category_group_model.dart';
import '../enum/transaction.dart';
import 'currency_service.dart';

class RankingService {
  // Hệ số chuyển đổi tiền thành điểm (1 điểm = 10,000 VND)
  static const double _pointsPerVND = 0.0001; // 1 VND = 0.0001 điểm
  static const double _vndPerPoint = 10000; // 1 điểm = 10,000 VND

  // Định nghĩa các hạng xếp hạng dựa trên điểm
  static const List<Ranking> _rankings = [
    Ranking(
      id: 'bronze',
      name: 'ranking.bronze_saver',
      minAmount: 0,
      maxAmount: 100, // 100 điểm = 1M VND
      color: Color(0xFFB8860B), // Darker bronze for better contrast
      iconName: 'bronze',
      description: 'ranking.bronze_description',
    ),
    Ranking(
      id: 'silver',
      name: 'ranking.silver_saver',
      minAmount: 100,
      maxAmount: 500, // 500 điểm = 5M VND
      color: Color(0xFF708090), // Slate gray for better contrast
      iconName: 'silver',
      description: 'ranking.silver_description',
    ),
    Ranking(
      id: 'gold',
      name: 'ranking.gold_saver',
      minAmount: 500,
      maxAmount: 1000, // 1000 điểm = 10M VND
      color: Color(0xFFB8860B), // Dark goldenrod for better contrast
      iconName: 'gold',
      description: 'ranking.gold_description',
    ),
    Ranking(
      id: 'platinum',
      name: 'ranking.platinum_saver',
      minAmount: 1000,
      maxAmount: 5000, // 5000 điểm = 50M VND
      color: Color(0xFF4682B4), // Steel blue for better contrast
      iconName: 'platinum',
      description: 'ranking.platinum_description',
    ),
    Ranking(
      id: 'diamond',
      name: 'ranking.diamond_saver',
      minAmount: 5000,
      maxAmount: double.infinity,
      color: Color(0xFF4169E1), // Royal blue for better contrast
      iconName: 'diamond',
      description: 'ranking.diamond_description',
    ),
  ];

  /// Chuyển đổi số tiền thành điểm
  static double convertMoneyToPoints(double amount, CurrencyType currencyType) {
    // Chuyển về VND trước
    final amountInVND = CurrencyService.convertCurrency(
      amount: amount,
      fromCurrency: currencyType,
      toCurrency: CurrencyType.vnd,
    );

    // Chuyển VND thành điểm
    return amountInVND * _pointsPerVND;
  }

  /// Chuyển đổi điểm thành số tiền theo loại tiền hiện tại
  static double convertPointsToMoney(double points, CurrencyType currencyType) {
    // Chuyển điểm thành VND
    final amountInVND = points * _vndPerPoint;

    // Chuyển VND về loại tiền hiện tại
    return CurrencyService.convertCurrency(
      amount: amountInVND,
      fromCurrency: CurrencyType.vnd,
      toCurrency: currencyType,
    );
  }

  /// Tính toán xếp hạng của user dựa trên điểm tiết kiệm
  static UserRanking calculateUserRanking({
    required List<Transaction> transactions,
    required List<CategoryGroup> categoryGroups,
    required String userId,
  }) {
    // Debug log
    print(
      'RankingService: Calculating ranking for ${transactions.length} transactions and ${categoryGroups.length} groups',
    );
    // Lấy loại tiền hiện tại
    final currentLocale = Intl.getCurrentLocale();
    final currentCurrencyType = CurrencyService.getCurrencyType(currentLocale);

    // Tính tổng thu và tổng chi
    double totalIncome = 0;
    double totalExpense = 0;

    for (final transaction in transactions) {
      // Convert về loại tiền hiện tại
      final originalCurrencyType = _getCurrencyTypeFromString(
        transaction.originalCurrency,
      );
      final convertedAmount = CurrencyService.convertCurrency(
        amount: transaction.amount,
        fromCurrency: originalCurrencyType,
        toCurrency: currentCurrencyType,
      );

      if (transaction.category == Category.income) {
        totalIncome += convertedAmount;
      } else {
        totalExpense += convertedAmount;
      }
    }

    // Tính tổng tiền tiết kiệm
    final totalSavings = totalIncome - totalExpense;

    // Tính điểm dựa trên số tiền tiết kiệm thực tế (chỉ khi tiết kiệm > 0)
    final totalSavingsPoints =
        totalSavings > 0
            ? convertMoneyToPoints(totalSavings, currentCurrencyType)
            : 0.0;

    // Debug log
    print(
      'RankingService: totalIncome = $totalIncome, totalExpense = $totalExpense, totalSavings = $totalSavings, totalSavingsPoints = $totalSavingsPoints',
    );

    // Tính tiết kiệm theo từng nhóm
    final groupSavings = _calculateGroupSavings(
      transactions,
      categoryGroups,
      currentCurrencyType,
    );

    // Xác định hạng hiện tại dựa trên điểm
    final currentRank = _getCurrentRank(totalSavingsPoints);

    // Debug log
    print(
      'RankingService: currentRank = ${currentRank.name}, totalSavingsPoints = $totalSavingsPoints, groupSavings count = ${groupSavings.length}',
    );

    return UserRanking(
      userId: userId,
      totalSavings: totalSavings,
      totalSavingsPoints: totalSavingsPoints,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      currentRank: currentRank,
      groupSavings: groupSavings,
    );
  }

  /// Tính tiết kiệm theo từng nhóm
  static List<CategoryGroupSavings> _calculateGroupSavings(
    List<Transaction> transactions,
    List<CategoryGroup> categoryGroups,
    CurrencyType currentCurrencyType,
  ) {
    final List<CategoryGroupSavings> groupSavings = [];

    for (final group in categoryGroups) {
      if (group.spendingLimit > 0) {
        // Tính tổng chi tiêu trong nhóm này
        double totalSpent = 0;
        for (final transaction in transactions) {
          if (transaction.groupId == group.uuid &&
              transaction.category == Category.expense) {
            // Convert về loại tiền hiện tại
            final originalCurrencyType = _getCurrencyTypeFromString(
              transaction.originalCurrency,
            );
            final convertedAmount = CurrencyService.convertCurrency(
              amount: transaction.amount,
              fromCurrency: originalCurrencyType,
              toCurrency: currentCurrencyType,
            );
            totalSpent += convertedAmount;
          }
        }

        // Convert spending limit về loại tiền hiện tại
        final spendingLimitInCurrentCurrency = CurrencyService.convertCurrency(
          amount: group.spendingLimit,
          fromCurrency:
              CurrencyType.vnd, // Giả sử spending limit được lưu bằng VND
          toCurrency: currentCurrencyType,
        );

        final remaining = spendingLimitInCurrentCurrency - totalSpent;
        final savingsPercentage =
            spendingLimitInCurrentCurrency > 0
                ? (remaining / spendingLimitInCurrentCurrency) * 100.0
                : 0.0;

        groupSavings.add(
          CategoryGroupSavings(
            groupId: group.uuid!,
            groupName: group.getLocalizedName(),
            spendingLimit: spendingLimitInCurrentCurrency,
            totalSpent: totalSpent,
            remaining: remaining,
            savingsPercentage: savingsPercentage,
          ),
        );
      }
    }

    return groupSavings;
  }

  /// Xác định hạng hiện tại dựa trên tổng điểm tiết kiệm
  static Ranking _getCurrentRank(double totalSavingsPoints) {
    // Nếu điểm <= 0, trả về hạng thấp nhất
    if (totalSavingsPoints <= 0) {
      return _rankings.first;
    }

    for (final ranking in _rankings) {
      if (totalSavingsPoints >= ranking.minAmount &&
          totalSavingsPoints < ranking.maxAmount) {
        return ranking;
      }
    }
    // Nếu vượt quá tất cả hạng, trả về hạng cao nhất
    return _rankings.last;
  }

  /// Lấy tất cả các hạng xếp hạng
  static List<Ranking> getAllRankings() {
    return _rankings;
  }

  /// Lấy hạng tiếp theo
  static Ranking? getNextRank(Ranking currentRank) {
    final currentIndex = _rankings.indexWhere((r) => r.id == currentRank.id);
    if (currentIndex >= 0 && currentIndex < _rankings.length - 1) {
      return _rankings[currentIndex + 1];
    }
    return null;
  }

  /// Tính phần trăm tiến độ đến hạng tiếp theo
  static double getProgressToNextRank(
    Ranking currentRank,
    double currentSavingsPoints,
  ) {
    final nextRank = getNextRank(currentRank);
    if (nextRank == null) {
      return 100.0; // Đã đạt hạng cao nhất
    }

    // Nếu điểm <= 0, tiến độ = 0
    if (currentSavingsPoints <= 0) {
      return 0.0;
    }

    final progress =
        (currentSavingsPoints - currentRank.minAmount) /
        (nextRank.minAmount - currentRank.minAmount);
    return (progress * 100.0).clamp(0.0, 100.0).toDouble();
  }

  /// Lấy CurrencyType từ string
  static CurrencyType _getCurrencyTypeFromString(String currencyString) {
    switch (currencyString.toUpperCase()) {
      case 'VND':
        return CurrencyType.vnd;
      case 'CNY':
        return CurrencyType.cny;
      case 'USD':
      default:
        return CurrencyType.usd;
    }
  }
}
