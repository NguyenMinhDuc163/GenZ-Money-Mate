import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/extension/extension.dart';
import '../../../../core/models/ranking_model.dart';
import '../../../../core/styles/app_text_style.dart';

class GroupSavingsCard extends StatelessWidget {
  final CategoryGroupSavings groupSavings;

  const GroupSavingsCard({super.key, required this.groupSavings});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverLimit = groupSavings.remaining < 0;
    final savingsColor =
        isOverLimit
            ? (isDark ? Colors.redAccent : Colors.red.shade600)
            : (isDark ? Colors.greenAccent : Colors.green.shade600);
    final progressValue =
        groupSavings.spendingLimit > 0
            ? (groupSavings.totalSpent / groupSavings.spendingLimit).clamp(
              0.0,
              1.0,
            )
            : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: savingsColor.withOpacity(isDark ? 0.4 : 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.shadow.withOpacity(isDark ? 0.1 : 0.05),
            blurRadius: 6,
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
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: savingsColor.withOpacity(isDark ? 0.15 : 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOverLimit
                      ? FontAwesomeIcons.exclamation
                      : FontAwesomeIcons.check,
                  color: savingsColor,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  groupSavings.groupName,
                  style: AppTextStyle.subtitle.copyWith(
                    color: context.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: savingsColor.withOpacity(isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${groupSavings.savingsPercentage.toStringAsFixed(1)}%',
                  style: AppTextStyle.caption.copyWith(
                    color: savingsColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress Bar
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: context.colorScheme.outline.withOpacity(
              isDark ? 0.3 : 0.2,
            ),
            valueColor: AlwaysStoppedAnimation<Color>(savingsColor),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
          const SizedBox(height: 12),

          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatItem(
                context,
                'ranking.spent'.tr(),
                groupSavings.totalSpent.toCurrencyWithSymbol(),
                FontAwesomeIcons.arrowDown,
                isDark ? Colors.redAccent : Colors.red.shade600,
              ),
              _buildStatItem(
                context,
                'ranking.limit'.tr(),
                groupSavings.spendingLimit.toCurrencyWithSymbol(),
                FontAwesomeIcons.chartLine,
                context.colorScheme.outline,
              ),
              _buildStatItem(
                context,
                'ranking.remaining'.tr(),
                groupSavings.remaining.toCurrencyWithSymbol(),
                FontAwesomeIcons.arrowUp,
                savingsColor,
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
    return Column(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyle.caption.copyWith(
            color: context.colorScheme.outline,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyle.caption.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
