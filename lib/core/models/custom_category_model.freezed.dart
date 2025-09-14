// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_category_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CustomCategory _$CustomCategoryFromJson(Map<String, dynamic> json) {
  return _CustomCategory.fromJson(json);
}

/// @nodoc
mixin _$CustomCategory {
  String? get uuid => throw _privateConstructorUsedError;
  String? get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get iconName =>
      throw _privateConstructorUsedError; // Tên icon từ FontAwesome
  int get colorValue =>
      throw _privateConstructorUsedError; // Màu sắc dưới dạng int
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isDefault =>
      throw _privateConstructorUsedError; // Đánh dấu category mặc định
  String get groupId => throw _privateConstructorUsedError;

  /// Serializes this CustomCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomCategoryCopyWith<CustomCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomCategoryCopyWith<$Res> {
  factory $CustomCategoryCopyWith(
          CustomCategory value, $Res Function(CustomCategory) then) =
      _$CustomCategoryCopyWithImpl<$Res, CustomCategory>;
  @useResult
  $Res call(
      {String? uuid,
      String? userId,
      String name,
      String iconName,
      int colorValue,
      DateTime createdAt,
      DateTime updatedAt,
      bool isDefault,
      String groupId});
}

/// @nodoc
class _$CustomCategoryCopyWithImpl<$Res, $Val extends CustomCategory>
    implements $CustomCategoryCopyWith<$Res> {
  _$CustomCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? userId = freezed,
    Object? name = null,
    Object? iconName = null,
    Object? colorValue = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDefault = null,
    Object? groupId = null,
  }) {
    return _then(_value.copyWith(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CustomCategoryImplCopyWith<$Res>
    implements $CustomCategoryCopyWith<$Res> {
  factory _$$CustomCategoryImplCopyWith(_$CustomCategoryImpl value,
          $Res Function(_$CustomCategoryImpl) then) =
      __$$CustomCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? uuid,
      String? userId,
      String name,
      String iconName,
      int colorValue,
      DateTime createdAt,
      DateTime updatedAt,
      bool isDefault,
      String groupId});
}

/// @nodoc
class __$$CustomCategoryImplCopyWithImpl<$Res>
    extends _$CustomCategoryCopyWithImpl<$Res, _$CustomCategoryImpl>
    implements _$$CustomCategoryImplCopyWith<$Res> {
  __$$CustomCategoryImplCopyWithImpl(
      _$CustomCategoryImpl _value, $Res Function(_$CustomCategoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of CustomCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uuid = freezed,
    Object? userId = freezed,
    Object? name = null,
    Object? iconName = null,
    Object? colorValue = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isDefault = null,
    Object? groupId = null,
  }) {
    return _then(_$CustomCategoryImpl(
      uuid: freezed == uuid
          ? _value.uuid
          : uuid // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      colorValue: null == colorValue
          ? _value.colorValue
          : colorValue // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomCategoryImpl implements _CustomCategory {
  const _$CustomCategoryImpl(
      {required this.uuid,
      required this.userId,
      required this.name,
      required this.iconName,
      required this.colorValue,
      required this.createdAt,
      required this.updatedAt,
      this.isDefault = false,
      this.groupId = ''});

  factory _$CustomCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomCategoryImplFromJson(json);

  @override
  final String? uuid;
  @override
  final String? userId;
  @override
  final String name;
  @override
  final String iconName;
// Tên icon từ FontAwesome
  @override
  final int colorValue;
// Màu sắc dưới dạng int
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isDefault;
// Đánh dấu category mặc định
  @override
  @JsonKey()
  final String groupId;

  @override
  String toString() {
    return 'CustomCategory(uuid: $uuid, userId: $userId, name: $name, iconName: $iconName, colorValue: $colorValue, createdAt: $createdAt, updatedAt: $updatedAt, isDefault: $isDefault, groupId: $groupId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomCategoryImpl &&
            (identical(other.uuid, uuid) || other.uuid == uuid) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.colorValue, colorValue) ||
                other.colorValue == colorValue) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.groupId, groupId) || other.groupId == groupId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uuid, userId, name, iconName,
      colorValue, createdAt, updatedAt, isDefault, groupId);

  /// Create a copy of CustomCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomCategoryImplCopyWith<_$CustomCategoryImpl> get copyWith =>
      __$$CustomCategoryImplCopyWithImpl<_$CustomCategoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomCategoryImplToJson(
      this,
    );
  }
}

abstract class _CustomCategory implements CustomCategory {
  const factory _CustomCategory(
      {required final String? uuid,
      required final String? userId,
      required final String name,
      required final String iconName,
      required final int colorValue,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isDefault,
      final String groupId}) = _$CustomCategoryImpl;

  factory _CustomCategory.fromJson(Map<String, dynamic> json) =
      _$CustomCategoryImpl.fromJson;

  @override
  String? get uuid;
  @override
  String? get userId;
  @override
  String get name;
  @override
  String get iconName; // Tên icon từ FontAwesome
  @override
  int get colorValue; // Màu sắc dưới dạng int
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isDefault; // Đánh dấu category mặc định
  @override
  String get groupId;

  /// Create a copy of CustomCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomCategoryImplCopyWith<_$CustomCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
