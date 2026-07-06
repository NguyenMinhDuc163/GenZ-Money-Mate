import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/ads/ad_service.dart';
import '../../../../core/app_injections.dart';
import '../../../../core/extension/extension.dart';
import '../../../../core/models/ranking_model.dart';
import '../../../../core/styles/app_text_style.dart';
import '../../domain/ranking_reward_insight.dart';

class RewardedInsightCard extends StatelessWidget {
  const RewardedInsightCard({super.key, required this.userRanking});

  final UserRanking userRanking;

  @override
  Widget build(BuildContext context) {
    final adService = getIt<AdService>();
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'ranking.rewarded_title'.tr(),
                    style: AppTextStyle.subtitle.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'ranking.rewarded_description'.tr(),
              style: AppTextStyle.body.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ValueListenableBuilder<bool>(
                valueListenable: adService.rankingRewardedReady,
                builder: (context, isReady, _) {
                  return FilledButton.icon(
                    onPressed: () => _showRewarded(context, adService),
                    icon: Icon(
                      isReady ? Icons.play_circle_fill : Icons.refresh,
                    ),
                    label: Text(
                      isReady
                          ? 'ranking.rewarded_button'.tr()
                          : 'ranking.rewarded_prepare'.tr(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRewarded(BuildContext context, AdService adService) async {
    final wasShown = await adService.showRankingRewarded(
      onRewardEarned: () {
        if (context.mounted) {
          _showInsightDialog(context);
        }
      },
    );

    if (!wasShown && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ranking.rewarded_unavailable'.tr())),
      );
    }
  }

  void _showInsightDialog(BuildContext context) {
    final insight = RankingRewardInsight.fromUserRanking(userRanking);

    showDialog<void>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text('ranking.insight_title'.tr()),
            content: Text(_messageFor(insight)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text('ranking.insight_close'.tr()),
              ),
            ],
          ),
    );
  }

  String _messageFor(RankingRewardInsight insight) {
    final group = insight.group;
    return switch (insight.type) {
      RankingRewardInsightType.overBudgetGroup => 'ranking.insight_over_budget'
          .tr(
            namedArgs: {
              'group': group!.groupName,
              'amount': group.remaining.abs().toCurrencyWithSymbol(),
            },
          ),
      RankingRewardInsightType.spendingExceedsIncome =>
        'ranking.insight_expense_high'.tr(),
      RankingRewardInsightType.focusGroup => 'ranking.insight_focus_group'.tr(
        namedArgs: {
          'group': group!.groupName,
          'percent': group.savingsPercentage.toStringAsFixed(1),
        },
      ),
      RankingRewardInsightType.positive => 'ranking.insight_positive'.tr(),
    };
  }
}
