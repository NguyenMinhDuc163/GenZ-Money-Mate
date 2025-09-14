import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extension/extension.dart';
import '../../../core/models/ranking_model.dart';
import '../../../core/service/ranking_service.dart';
import '../../../core/styles/app_text_style.dart';
import '../../ranking/bloc/ranking_cubit.dart';
import 'widgets/ranking_card.dart';
import 'widgets/group_savings_card.dart';
import 'widgets/ranking_progress_card.dart';

class RankingView extends StatefulWidget {
  const RankingView({super.key});

  @override
  State<RankingView> createState() => _RankingViewState();
}

class _RankingViewState extends State<RankingView> {
  @override
  void initState() {
    super.initState();
    // Load dữ liệu khi vào màn hình
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('RankingView: Loading ranking data...');
      context.read<RankingCubit>().loadRankingData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? context.colorScheme.background : Colors.grey.shade50,
      appBar: AppBar(
        title: Text('ranking.title'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: isDark ? context.colorScheme.surface : Colors.white,
        elevation: isDark ? 2 : 1,
      ),
      body: BlocBuilder<RankingCubit, RankingState>(
        builder: (context, rankingState) {
          print('RankingView: RankingState = $rankingState');
          return rankingState.maybeWhen(
            loading: () => _buildLoadingState(context),
            loaded: (userRanking) => _buildRankingContent(context, userRanking),
            error: (message) => _buildErrorState(context, message),
            orElse: () {
              print('RankingView: RankingState is initial, showing loading');
              return _buildLoadingState(context);
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color:
                isDark
                    ? context.colorScheme.primary
                    : context.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'ranking.loading'.tr(),
            style: AppTextStyle.body.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color:
                isDark
                    ? context.colorScheme.error
                    : context.colorScheme.error.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Text(
            'ranking.error_title'.tr(),
            style: AppTextStyle.subtitle.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: AppTextStyle.body.copyWith(
              color: context.colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRankingContent(BuildContext context, UserRanking userRanking) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Debug log
    print('RankingView: userRanking loaded - ${userRanking.currentRank.name}');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Rank Card
          RankingCard(userRanking: userRanking),
          const SizedBox(height: 16),

          // Progress to Next Rank
          RankingProgressCard(userRanking: userRanking),
          const SizedBox(height: 16),

          // Group Savings
          if (userRanking.groupSavings.isNotEmpty) ...[
            Text(
              'ranking.group_savings'.tr(),
              style: AppTextStyle.title.copyWith(
                color:
                    isDark
                        ? context.colorScheme.onSurface
                        : Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            ...userRanking.groupSavings.map(
              (groupSavings) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GroupSavingsCard(groupSavings: groupSavings),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // All Rankings
          Text(
            'ranking.all_ranks'.tr(),
            style: AppTextStyle.title.copyWith(
              color:
                  isDark ? context.colorScheme.onSurface : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 12),
          _buildAllRankingsList(context, userRanking.currentRank),
        ],
      ),
    );
  }

  Widget _buildAllRankingsList(BuildContext context, Ranking currentRank) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allRankings = RankingService.getAllRankings();

    return Column(
      children:
          allRankings.map((ranking) {
            final isCurrentRank = ranking.id == currentRank.id;
            final isUnlocked = ranking.minAmount <= currentRank.minAmount;

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color:
                    isCurrentRank
                        ? ranking.color.withOpacity(isDark ? 0.1 : 0.15)
                        : (isDark ? context.colorScheme.surface : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border:
                    isCurrentRank
                        ? Border.all(color: ranking.color, width: 2)
                        : Border.all(
                          color:
                              isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade200,
                          width: 1,
                        ),
                boxShadow: [
                  BoxShadow(
                    color:
                        isDark
                            ? Colors.black.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isUnlocked ? ranking.color : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(ranking.icon, color: Colors.white, size: 24),
                ),
                title: Text(
                  ranking.name.tr(),
                  style: AppTextStyle.subtitle.copyWith(
                    color:
                        isUnlocked
                            ? (isDark
                                ? context.colorScheme.onSurface
                                : Colors.grey.shade800)
                            : (isDark
                                ? context.colorScheme.outline
                                : Colors.grey.shade400),
                    fontWeight:
                        isCurrentRank ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ranking.description.tr(),
                      style: AppTextStyle.caption.copyWith(
                        color:
                            isUnlocked
                                ? (isDark
                                    ? context.colorScheme.outline
                                    : Colors.grey.shade600)
                                : (isDark
                                    ? context.colorScheme.outline.withOpacity(
                                      0.5,
                                    )
                                    : Colors.grey.shade400),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${ranking.minAmount.toStringAsFixed(0)} ${'ranking.points'.tr()}',
                          style: AppTextStyle.caption.copyWith(
                            color:
                                isUnlocked
                                    ? (isDark
                                        ? context.colorScheme.primary
                                        : Colors.blue.shade600)
                                    : (isDark
                                        ? context.colorScheme.outline
                                            .withOpacity(0.5)
                                        : Colors.grey.shade400),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing:
                    isCurrentRank
                        ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ranking.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ranking.current'.tr(),
                            style: AppTextStyle.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : Icon(
                          isUnlocked ? Icons.check_circle : Icons.lock,
                          color: isUnlocked ? Colors.green : Colors.grey,
                        ),
              ),
            );
          }).toList(),
    );
  }
}
