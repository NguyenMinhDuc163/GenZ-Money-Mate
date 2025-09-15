// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RankingImpl _$$RankingImplFromJson(Map<String, dynamic> json) =>
    _$RankingImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      minAmount: (json['minAmount'] as num).toDouble(),
      maxAmount: (json['maxAmount'] as num).toDouble(),
      color: const ColorConverter().fromJson((json['color'] as num).toInt()),
      iconName: json['iconName'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$RankingImplToJson(_$RankingImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'minAmount': instance.minAmount,
      'maxAmount': instance.maxAmount,
      'color': const ColorConverter().toJson(instance.color),
      'iconName': instance.iconName,
      'description': instance.description,
    };

_$UserRankingImpl _$$UserRankingImplFromJson(Map<String, dynamic> json) =>
    _$UserRankingImpl(
      userId: json['userId'] as String,
      totalSavings: (json['totalSavings'] as num).toDouble(),
      totalSavingsPoints: (json['totalSavingsPoints'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpense: (json['totalExpense'] as num).toDouble(),
      currentRank:
          Ranking.fromJson(json['currentRank'] as Map<String, dynamic>),
      groupSavings: (json['groupSavings'] as List<dynamic>)
          .map((e) => CategoryGroupSavings.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserRankingImplToJson(_$UserRankingImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'totalSavings': instance.totalSavings,
      'totalSavingsPoints': instance.totalSavingsPoints,
      'totalIncome': instance.totalIncome,
      'totalExpense': instance.totalExpense,
      'currentRank': instance.currentRank,
      'groupSavings': instance.groupSavings,
    };

_$CategoryGroupSavingsImpl _$$CategoryGroupSavingsImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoryGroupSavingsImpl(
      groupId: json['groupId'] as String,
      groupName: json['groupName'] as String,
      spendingLimit: (json['spendingLimit'] as num).toDouble(),
      totalSpent: (json['totalSpent'] as num).toDouble(),
      remaining: (json['remaining'] as num).toDouble(),
      savingsPercentage: (json['savingsPercentage'] as num).toDouble(),
    );

Map<String, dynamic> _$$CategoryGroupSavingsImplToJson(
        _$CategoryGroupSavingsImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'groupName': instance.groupName,
      'spendingLimit': instance.spendingLimit,
      'totalSpent': instance.totalSpent,
      'remaining': instance.remaining,
      'savingsPercentage': instance.savingsPercentage,
    };
