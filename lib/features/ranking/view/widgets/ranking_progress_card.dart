import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/models/ranking_model.dart';
import '../../../../core/service/ranking_service.dart';
import '../../../../core/styles/app_text_style.dart';

class RankingProgressCard extends StatelessWidget {
  final UserRanking userRanking;

  const RankingProgressCard({super.key, required this.userRanking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextRank = RankingService.getNextRank(userRanking.currentRank);
    final progress = RankingService.getProgressToNextRank(
      userRanking.currentRank,
      userRanking.totalSavingsPoints,
    );

    if (nextRank == null) {
      // Đã đạt hạng cao nhất
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: userRanking.currentRank.color.withOpacity(
              isDark ? 0.8 : 0.6,
            ),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: userRanking.currentRank.color.withOpacity(
                isDark ? 0.1 : 0.05,
              ),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.emoji_events,
              size: 48,
              color: userRanking.currentRank.color,
            ),
            const SizedBox(height: 12),
            Text(
              'ranking.max_rank_achieved'.tr(),
              style: AppTextStyle.subtitle.copyWith(
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ranking.max_rank_description'.tr(),
              style: AppTextStyle.body.copyWith(
                color: context.colorScheme.outline,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(isDark ? 0.1 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.trending_up,
                color: context.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'ranking.progress_to_next'.tr(),
                style: AppTextStyle.subtitle.copyWith(
                  color: context.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Next Rank Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: nextRank.color.withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: nextRank.color.withOpacity(isDark ? 0.3 : 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: nextRank.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(nextRank.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextRank.name.tr(),
                        style: AppTextStyle.body.copyWith(
                          color: context.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        nextRank.description.tr(),
                        style: AppTextStyle.caption.copyWith(
                          color: context.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ranking.progress'.tr(),
                    style: AppTextStyle.caption.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                  Text(
                    '${progress.toStringAsFixed(1)}%',
                    style: AppTextStyle.caption.copyWith(
                      color: context.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: context.colorScheme.outline.withOpacity(
                  isDark ? 0.3 : 0.2,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(nextRank.color),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ranking.need_more_points'.tr(),
                    style: AppTextStyle.caption.copyWith(
                      color: context.colorScheme.outline,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${(nextRank.minAmount - userRanking.totalSavingsPoints).toStringAsFixed(1)} ${'ranking.points'.tr()}',
                        style: AppTextStyle.caption.copyWith(
                          color: context.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
