// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryGroupImpl _$$CategoryGroupImplFromJson(Map<String, dynamic> json) =>
    _$CategoryGroupImpl(
      uuid: json['uuid'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
      spendingLimit: (json['spendingLimit'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$CategoryGroupImplToJson(_$CategoryGroupImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'userId': instance.userId,
      'name': instance.name,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isDefault': instance.isDefault,
      'spendingLimit': instance.spendingLimit,
    };
