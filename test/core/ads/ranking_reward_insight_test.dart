import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genz_money_mate/core/models/ranking_model.dart';
import 'package:genz_money_mate/features/ranking/domain/ranking_reward_insight.dart';

void main() {
  test('prioritizes the group furthest over budget', () {
    final insight = RankingRewardInsight.fromUserRanking(
      _ranking(
        groups: [
          _group(name: 'Food', remaining: -100),
          _group(name: 'Travel', remaining: -250),
        ],
      ),
    );

    expect(insight.type, RankingRewardInsightType.overBudgetGroup);
    expect(insight.group?.groupName, 'Travel');
  });

  test('warns when total spending exceeds income', () {
    final insight = RankingRewardInsight.fromUserRanking(
      _ranking(totalIncome: 100, totalExpense: 120),
    );

    expect(insight.type, RankingRewardInsightType.spendingExceedsIncome);
  });

  test('selects the group with the lowest savings percentage', () {
    final insight = RankingRewardInsight.fromUserRanking(
      _ranking(
        groups: [
          _group(name: 'Food', remaining: 100, savingsPercentage: 25),
          _group(name: 'Travel', remaining: 100, savingsPercentage: 10),
        ],
      ),
    );

    expect(insight.type, RankingRewardInsightType.focusGroup);
    expect(insight.group?.groupName, 'Travel');
  });
}

UserRanking _ranking({
  double totalIncome = 200,
  double totalExpense = 100,
  List<CategoryGroupSavings> groups = const [],
}) {
  return UserRanking(
    userId: 'test-user',
    totalSavings: totalIncome - totalExpense,
    totalSavingsPoints: 10,
    totalIncome: totalIncome,
    totalExpense: totalExpense,
    currentRank: const Ranking(
      id: 'bronze',
      name: 'Bronze',
      minAmount: 0,
      maxAmount: 100,
      color: Colors.brown,
      iconName: 'bronze',
      description: 'Test rank',
    ),
    groupSavings: groups,
  );
}

CategoryGroupSavings _group({
  required String name,
  required double remaining,
  double savingsPercentage = 0,
}) {
  return CategoryGroupSavings(
    groupId: name.toLowerCase(),
    groupName: name,
    spendingLimit: 1000,
    totalSpent: 1000 - remaining,
    remaining: remaining,
    savingsPercentage: savingsPercentage,
  );
}
