import '../../../core/models/ranking_model.dart';

enum RankingRewardInsightType {
  overBudgetGroup,
  spendingExceedsIncome,
  focusGroup,
  positive,
}

class RankingRewardInsight {
  const RankingRewardInsight({required this.type, this.group});

  final RankingRewardInsightType type;
  final CategoryGroupSavings? group;

  factory RankingRewardInsight.fromUserRanking(UserRanking ranking) {
    final overBudgetGroups =
        ranking.groupSavings.where((group) => group.remaining < 0).toList();
    if (overBudgetGroups.isNotEmpty) {
      overBudgetGroups.sort((a, b) => a.remaining.compareTo(b.remaining));
      return RankingRewardInsight(
        type: RankingRewardInsightType.overBudgetGroup,
        group: overBudgetGroups.first,
      );
    }

    if (ranking.totalExpense > ranking.totalIncome) {
      return const RankingRewardInsight(
        type: RankingRewardInsightType.spendingExceedsIncome,
      );
    }

    if (ranking.groupSavings.isNotEmpty) {
      final groups = [...ranking.groupSavings]
        ..sort((a, b) => a.savingsPercentage.compareTo(b.savingsPercentage));
      return RankingRewardInsight(
        type: RankingRewardInsightType.focusGroup,
        group: groups.first,
      );
    }

    return const RankingRewardInsight(type: RankingRewardInsightType.positive);
  }
}
