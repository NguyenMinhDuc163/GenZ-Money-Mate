// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CustomCategoryImpl _$$CustomCategoryImplFromJson(Map<String, dynamic> json) =>
    _$CustomCategoryImpl(
      uuid: json['uuid'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String,
      iconName: json['iconName'] as String,
      colorValue: (json['colorValue'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$$CustomCategoryImplToJson(
        _$CustomCategoryImpl instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'userId': instance.userId,
      'name': instance.name,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isDefault': instance.isDefault,
    };
