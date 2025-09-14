import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'ranking_model.freezed.dart';
part 'ranking_model.g.dart';

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}

@freezed
class Ranking with _$Ranking {
  const factory Ranking({
    required String id,
    required String name,
    required double minAmount,
    required double maxAmount,
    @ColorConverter() required Color color,
    required String iconName,
    required String description,
  }) = _Ranking;

  factory Ranking.fromJson(Map<String, dynamic> json) =>
      _$RankingFromJson(json);
}

@freezed
class UserRanking with _$UserRanking {
  const factory UserRanking({
    required String userId,
    required double totalSavings,
    required double totalSavingsPoints,
    required double totalIncome,
    required double totalExpense,
    required Ranking currentRank,
    required List<CategoryGroupSavings> groupSavings,
  }) = _UserRanking;

  factory UserRanking.fromJson(Map<String, dynamic> json) =>
      _$UserRankingFromJson(json);
}

@freezed
class CategoryGroupSavings with _$CategoryGroupSavings {
  const factory CategoryGroupSavings({
    required String groupId,
    required String groupName,
    required double spendingLimit,
    required double totalSpent,
    required double remaining,
    required double savingsPercentage,
  }) = _CategoryGroupSavings;

  factory CategoryGroupSavings.fromJson(Map<String, dynamic> json) =>
      _$CategoryGroupSavingsFromJson(json);
}

extension RankingExtension on Ranking {
  /// Lấy icon từ iconName
  IconData get icon {
    switch (iconName) {
      case 'bronze':
        return Icons.emoji_events;
      case 'silver':
        return Icons.emoji_events;
      case 'gold':
        return Icons.emoji_events;
      case 'platinum':
        return Icons.emoji_events;
      case 'diamond':
        return Icons.diamond;
      default:
        return Icons.emoji_events;
    }
  }
}
