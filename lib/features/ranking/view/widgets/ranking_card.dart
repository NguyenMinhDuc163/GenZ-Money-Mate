import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/models/ranking_model.dart';
import '../../../../core/styles/app_text_style.dart';

class RankingCard extends StatelessWidget {
  final UserRanking userRanking;

  const RankingCard({super.key, required this.userRanking});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rankColor = userRanking.currentRank.color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              isDark
                  ? [rankColor.withOpacity(0.8), rankColor.withOpacity(0.6)]
                  : [rankColor.withOpacity(0.25), rankColor.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: rankColor.withOpacity(isDark ? 0.3 : 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Rank Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: rankColor.withOpacity(isDark ? 0.3 : 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              userRanking.currentRank.icon,
              size: 40,
              color: isDark ? Colors.white : rankColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),

          // Rank Name
          Text(
            userRanking.currentRank.name.tr(),
            style: AppTextStyle.title2.copyWith(
              color: isDark ? Colors.white : Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Rank Description
          Text(
            userRanking.currentRank.description.tr(),
            style: AppTextStyle.body.copyWith(
              color:
                  isDark ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Points Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: rankColor.withOpacity(isDark ? 0.3 : 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: rankColor.withOpacity(isDark ? 0.1 : 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.star,
                      color: isDark ? Colors.amber : Colors.amber.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'ranking.total_points'.tr(),
                      style: AppTextStyle.caption.copyWith(
                        color:
                            isDark
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  userRanking.totalSavingsPoints > 0
                      ? '${userRanking.totalSavingsPoints.toStringAsFixed(1)} ${'ranking.points'.tr()}'
                      : '0 ${'ranking.points'.tr()}',
                  style: AppTextStyle.title3.copyWith(
                    color:
                        userRanking.totalSavingsPoints > 0
                            ? (isDark ? Colors.white : Colors.grey.shade800)
                            : (isDark ? Colors.redAccent : Colors.red.shade600),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ranking.total_savings'.tr(),
                  style: AppTextStyle.caption.copyWith(
                    color:
                        isDark
                            ? Colors.white.withOpacity(0.6)
                            : Colors.grey.shade500,
                  ),
                ),
                Text(
                  userRanking.totalSavings.toCurrencyWithSymbol(),
                  style: AppTextStyle.body.copyWith(
                    color:
                        userRanking.totalSavings > 0
                            ? (isDark
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade700)
                            : (isDark ? Colors.redAccent : Colors.red.shade600),
                  ),
                ),
                if (userRanking.totalSavingsPoints <= 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isDark
                              ? Colors.red.withOpacity(0.2)
                              : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? Colors.redAccent : Colors.red.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color:
                              isDark ? Colors.redAccent : Colors.red.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'ranking.no_savings_warning'.tr(),
                          style: AppTextStyle.caption.copyWith(
                            color:
                                isDark ? Colors.redAccent : Colors.red.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Income vs Expense
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                'ranking.total_income'.tr(),
                userRanking.totalIncome.toCurrencyWithSymbol(),
                FontAwesomeIcons.arrowUp,
                isDark ? Colors.greenAccent : Colors.green.shade600,
              ),
              _buildStatItem(
                context,
                'ranking.total_expense'.tr(),
                userRanking.totalExpense.toCurrencyWithSymbol(),
                FontAwesomeIcons.arrowDown,
                isDark ? Colors.redAccent : Colors.red.shade600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Icon(
          icon,
          color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.caption.copyWith(
            color:
                isDark ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyle.body.copyWith(
            color: isDark ? Colors.white : Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
