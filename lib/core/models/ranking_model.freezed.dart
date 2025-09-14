// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Ranking _$RankingFromJson(Map<String, dynamic> json) {
  return _Ranking.fromJson(json);
}

/// @nodoc
mixin _$Ranking {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get minAmount => throw _privateConstructorUsedError;
  double get maxAmount => throw _privateConstructorUsedError;
  @ColorConverter()
  Color get color => throw _privateConstructorUsedError;
  String get iconName => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this Ranking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RankingCopyWith<Ranking> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RankingCopyWith<$Res> {
  factory $RankingCopyWith(Ranking value, $Res Function(Ranking) then) =
      _$RankingCopyWithImpl<$Res, Ranking>;
  @useResult
  $Res call(
      {String id,
      String name,
      double minAmount,
      double maxAmount,
      @ColorConverter() Color color,
      String iconName,
      String description});
}

/// @nodoc
class _$RankingCopyWithImpl<$Res, $Val extends Ranking>
    implements $RankingCopyWith<$Res> {
  _$RankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? minAmount = null,
    Object? maxAmount = null,
    Object? color = null,
    Object? iconName = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RankingImplCopyWith<$Res> implements $RankingCopyWith<$Res> {
  factory _$$RankingImplCopyWith(
          _$RankingImpl value, $Res Function(_$RankingImpl) then) =
      __$$RankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      double minAmount,
      double maxAmount,
      @ColorConverter() Color color,
      String iconName,
      String description});
}

/// @nodoc
class __$$RankingImplCopyWithImpl<$Res>
    extends _$RankingCopyWithImpl<$Res, _$RankingImpl>
    implements _$$RankingImplCopyWith<$Res> {
  __$$RankingImplCopyWithImpl(
      _$RankingImpl _value, $Res Function(_$RankingImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? minAmount = null,
    Object? maxAmount = null,
    Object? color = null,
    Object? iconName = null,
    Object? description = null,
  }) {
    return _then(_$RankingImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      minAmount: null == minAmount
          ? _value.minAmount
          : minAmount // ignore: cast_nullable_to_non_nullable
              as double,
      maxAmount: null == maxAmount
          ? _value.maxAmount
          : maxAmount // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      iconName: null == iconName
          ? _value.iconName
          : iconName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RankingImpl implements _Ranking {
  const _$RankingImpl(
      {required this.id,
      required this.name,
      required this.minAmount,
      required this.maxAmount,
      @ColorConverter() required this.color,
      required this.iconName,
      required this.description});

  factory _$RankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$RankingImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double minAmount;
  @override
  final double maxAmount;
  @override
  @ColorConverter()
  final Color color;
  @override
  final String iconName;
  @override
  final String description;

  @override
  String toString() {
    return 'Ranking(id: $id, name: $name, minAmount: $minAmount, maxAmount: $maxAmount, color: $color, iconName: $iconName, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RankingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.minAmount, minAmount) ||
                other.minAmount == minAmount) &&
            (identical(other.maxAmount, maxAmount) ||
                other.maxAmount == maxAmount) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.iconName, iconName) ||
                other.iconName == iconName) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, minAmount, maxAmount,
      color, iconName, description);

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RankingImplCopyWith<_$RankingImpl> get copyWith =>
      __$$RankingImplCopyWithImpl<_$RankingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RankingImplToJson(
      this,
    );
  }
}

abstract class _Ranking implements Ranking {
  const factory _Ranking(
      {required final String id,
      required final String name,
      required final double minAmount,
      required final double maxAmount,
      @ColorConverter() required final Color color,
      required final String iconName,
      required final String description}) = _$RankingImpl;

  factory _Ranking.fromJson(Map<String, dynamic> json) = _$RankingImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get minAmount;
  @override
  double get maxAmount;
  @override
  @ColorConverter()
  Color get color;
  @override
  String get iconName;
  @override
  String get description;

  /// Create a copy of Ranking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RankingImplCopyWith<_$RankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserRanking _$UserRankingFromJson(Map<String, dynamic> json) {
  return _UserRanking.fromJson(json);
}

/// @nodoc
mixin _$UserRanking {
  String get userId => throw _privateConstructorUsedError;
  double get totalSavings => throw _privateConstructorUsedError;
  double get totalSavingsPoints => throw _privateConstructorUsedError;
  double get totalIncome => throw _privateConstructorUsedError;
  double get totalExpense => throw _privateConstructorUsedError;
  Ranking get currentRank => throw _privateConstructorUsedError;
  List<CategoryGroupSavings> get groupSavings =>
      throw _privateConstructorUsedError;

  /// Serializes this UserRanking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserRankingCopyWith<UserRanking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserRankingCopyWith<$Res> {
  factory $UserRankingCopyWith(
          UserRanking value, $Res Function(UserRanking) then) =
      _$UserRankingCopyWithImpl<$Res, UserRanking>;
  @useResult
  $Res call(
      {String userId,
      double totalSavings,
      double totalSavingsPoints,
      double totalIncome,
      double totalExpense,
      Ranking currentRank,
      List<CategoryGroupSavings> groupSavings});

  $RankingCopyWith<$Res> get currentRank;
}

/// @nodoc
class _$UserRankingCopyWithImpl<$Res, $Val extends UserRanking>
    implements $UserRankingCopyWith<$Res> {
  _$UserRankingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalSavings = null,
    Object? totalSavingsPoints = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? currentRank = null,
    Object? groupSavings = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalSavings: null == totalSavings
          ? _value.totalSavings
          : totalSavings // ignore: cast_nullable_to_non_nullable
              as double,
      totalSavingsPoints: null == totalSavingsPoints
          ? _value.totalSavingsPoints
          : totalSavingsPoints // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      currentRank: null == currentRank
          ? _value.currentRank
          : currentRank // ignore: cast_nullable_to_non_nullable
              as Ranking,
      groupSavings: null == groupSavings
          ? _value.groupSavings
          : groupSavings // ignore: cast_nullable_to_non_nullable
              as List<CategoryGroupSavings>,
    ) as $Val);
  }

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RankingCopyWith<$Res> get currentRank {
    return $RankingCopyWith<$Res>(_value.currentRank, (value) {
      return _then(_value.copyWith(currentRank: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserRankingImplCopyWith<$Res>
    implements $UserRankingCopyWith<$Res> {
  factory _$$UserRankingImplCopyWith(
          _$UserRankingImpl value, $Res Function(_$UserRankingImpl) then) =
      __$$UserRankingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userId,
      double totalSavings,
      double totalSavingsPoints,
      double totalIncome,
      double totalExpense,
      Ranking currentRank,
      List<CategoryGroupSavings> groupSavings});

  @override
  $RankingCopyWith<$Res> get currentRank;
}

/// @nodoc
class __$$UserRankingImplCopyWithImpl<$Res>
    extends _$UserRankingCopyWithImpl<$Res, _$UserRankingImpl>
    implements _$$UserRankingImplCopyWith<$Res> {
  __$$UserRankingImplCopyWithImpl(
      _$UserRankingImpl _value, $Res Function(_$UserRankingImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? totalSavings = null,
    Object? totalSavingsPoints = null,
    Object? totalIncome = null,
    Object? totalExpense = null,
    Object? currentRank = null,
    Object? groupSavings = null,
  }) {
    return _then(_$UserRankingImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      totalSavings: null == totalSavings
          ? _value.totalSavings
          : totalSavings // ignore: cast_nullable_to_non_nullable
              as double,
      totalSavingsPoints: null == totalSavingsPoints
          ? _value.totalSavingsPoints
          : totalSavingsPoints // ignore: cast_nullable_to_non_nullable
              as double,
      totalIncome: null == totalIncome
          ? _value.totalIncome
          : totalIncome // ignore: cast_nullable_to_non_nullable
              as double,
      totalExpense: null == totalExpense
          ? _value.totalExpense
          : totalExpense // ignore: cast_nullable_to_non_nullable
              as double,
      currentRank: null == currentRank
          ? _value.currentRank
          : currentRank // ignore: cast_nullable_to_non_nullable
              as Ranking,
      groupSavings: null == groupSavings
          ? _value._groupSavings
          : groupSavings // ignore: cast_nullable_to_non_nullable
              as List<CategoryGroupSavings>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserRankingImpl implements _UserRanking {
  const _$UserRankingImpl(
      {required this.userId,
      required this.totalSavings,
      required this.totalSavingsPoints,
      required this.totalIncome,
      required this.totalExpense,
      required this.currentRank,
      required final List<CategoryGroupSavings> groupSavings})
      : _groupSavings = groupSavings;

  factory _$UserRankingImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserRankingImplFromJson(json);

  @override
  final String userId;
  @override
  final double totalSavings;
  @override
  final double totalSavingsPoints;
  @override
  final double totalIncome;
  @override
  final double totalExpense;
  @override
  final Ranking currentRank;
  final List<CategoryGroupSavings> _groupSavings;
  @override
  List<CategoryGroupSavings> get groupSavings {
    if (_groupSavings is EqualUnmodifiableListView) return _groupSavings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_groupSavings);
  }

  @override
  String toString() {
    return 'UserRanking(userId: $userId, totalSavings: $totalSavings, totalSavingsPoints: $totalSavingsPoints, totalIncome: $totalIncome, totalExpense: $totalExpense, currentRank: $currentRank, groupSavings: $groupSavings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserRankingImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.totalSavings, totalSavings) ||
                other.totalSavings == totalSavings) &&
            (identical(other.totalSavingsPoints, totalSavingsPoints) ||
                other.totalSavingsPoints == totalSavingsPoints) &&
            (identical(other.totalIncome, totalIncome) ||
                other.totalIncome == totalIncome) &&
            (identical(other.totalExpense, totalExpense) ||
                other.totalExpense == totalExpense) &&
            (identical(other.currentRank, currentRank) ||
                other.currentRank == currentRank) &&
            const DeepCollectionEquality()
                .equals(other._groupSavings, _groupSavings));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      totalSavings,
      totalSavingsPoints,
      totalIncome,
      totalExpense,
      currentRank,
      const DeepCollectionEquality().hash(_groupSavings));

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserRankingImplCopyWith<_$UserRankingImpl> get copyWith =>
      __$$UserRankingImplCopyWithImpl<_$UserRankingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserRankingImplToJson(
      this,
    );
  }
}

abstract class _UserRanking implements UserRanking {
  const factory _UserRanking(
          {required final String userId,
          required final double totalSavings,
          required final double totalSavingsPoints,
          required final double totalIncome,
          required final double totalExpense,
          required final Ranking currentRank,
          required final List<CategoryGroupSavings> groupSavings}) =
      _$UserRankingImpl;

  factory _UserRanking.fromJson(Map<String, dynamic> json) =
      _$UserRankingImpl.fromJson;

  @override
  String get userId;
  @override
  double get totalSavings;
  @override
  double get totalSavingsPoints;
  @override
  double get totalIncome;
  @override
  double get totalExpense;
  @override
  Ranking get currentRank;
  @override
  List<CategoryGroupSavings> get groupSavings;

  /// Create a copy of UserRanking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserRankingImplCopyWith<_$UserRankingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CategoryGroupSavings _$CategoryGroupSavingsFromJson(Map<String, dynamic> json) {
  return _CategoryGroupSavings.fromJson(json);
}

/// @nodoc
mixin _$CategoryGroupSavings {
  String get groupId => throw _privateConstructorUsedError;
  String get groupName => throw _privateConstructorUsedError;
  double get spendingLimit => throw _privateConstructorUsedError;
  double get totalSpent => throw _privateConstructorUsedError;
  double get remaining => throw _privateConstructorUsedError;
  double get savingsPercentage => throw _privateConstructorUsedError;

  /// Serializes this CategoryGroupSavings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoryGroupSavings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoryGroupSavingsCopyWith<CategoryGroupSavings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoryGroupSavingsCopyWith<$Res> {
  factory $CategoryGroupSavingsCopyWith(CategoryGroupSavings value,
          $Res Function(CategoryGroupSavings) then) =
      _$CategoryGroupSavingsCopyWithImpl<$Res, CategoryGroupSavings>;
  @useResult
  $Res call(
      {String groupId,
      String groupName,
      double spendingLimit,
      double totalSpent,
      double remaining,
      double savingsPercentage});
}

/// @nodoc
class _$CategoryGroupSavingsCopyWithImpl<$Res,
        $Val extends CategoryGroupSavings>
    implements $CategoryGroupSavingsCopyWith<$Res> {
  _$CategoryGroupSavingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoryGroupSavings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? spendingLimit = null,
    Object? totalSpent = null,
    Object? remaining = null,
    Object? savingsPercentage = null,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      spendingLimit: null == spendingLimit
          ? _value.spendingLimit
          : spendingLimit // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPercentage: null == savingsPercentage
          ? _value.savingsPercentage
          : savingsPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoryGroupSavingsImplCopyWith<$Res>
    implements $CategoryGroupSavingsCopyWith<$Res> {
  factory _$$CategoryGroupSavingsImplCopyWith(_$CategoryGroupSavingsImpl value,
          $Res Function(_$CategoryGroupSavingsImpl) then) =
      __$$CategoryGroupSavingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String groupId,
      String groupName,
      double spendingLimit,
      double totalSpent,
      double remaining,
      double savingsPercentage});
}

/// @nodoc
class __$$CategoryGroupSavingsImplCopyWithImpl<$Res>
    extends _$CategoryGroupSavingsCopyWithImpl<$Res, _$CategoryGroupSavingsImpl>
    implements _$$CategoryGroupSavingsImplCopyWith<$Res> {
  __$$CategoryGroupSavingsImplCopyWithImpl(_$CategoryGroupSavingsImpl _value,
      $Res Function(_$CategoryGroupSavingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoryGroupSavings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? groupName = null,
    Object? spendingLimit = null,
    Object? totalSpent = null,
    Object? remaining = null,
    Object? savingsPercentage = null,
  }) {
    return _then(_$CategoryGroupSavingsImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      groupName: null == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String,
      spendingLimit: null == spendingLimit
          ? _value.spendingLimit
          : spendingLimit // ignore: cast_nullable_to_non_nullable
              as double,
      totalSpent: null == totalSpent
          ? _value.totalSpent
          : totalSpent // ignore: cast_nullable_to_non_nullable
              as double,
      remaining: null == remaining
          ? _value.remaining
          : remaining // ignore: cast_nullable_to_non_nullable
              as double,
      savingsPercentage: null == savingsPercentage
          ? _value.savingsPercentage
          : savingsPercentage // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoryGroupSavingsImpl implements _CategoryGroupSavings {
  const _$CategoryGroupSavingsImpl(
      {required this.groupId,
      required this.groupName,
      required this.spendingLimit,
      required this.totalSpent,
      required this.remaining,
      required this.savingsPercentage});

  factory _$CategoryGroupSavingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoryGroupSavingsImplFromJson(json);

  @override
  final String groupId;
  @override
  final String groupName;
  @override
  final double spendingLimit;
  @override
  final double totalSpent;
  @override
  final double remaining;
  @override
  final double savingsPercentage;

  @override
  String toString() {
    return 'CategoryGroupSavings(groupId: $groupId, groupName: $groupName, spendingLimit: $spendingLimit, totalSpent: $totalSpent, remaining: $remaining, savingsPercentage: $savingsPercentage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoryGroupSavingsImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.spendingLimit, spendingLimit) ||
                other.spendingLimit == spendingLimit) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.remaining, remaining) ||
                other.remaining == remaining) &&
            (identical(other.savingsPercentage, savingsPercentage) ||
                other.savingsPercentage == savingsPercentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, groupId, groupName,
      spendingLimit, totalSpent, remaining, savingsPercentage);

  /// Create a copy of CategoryGroupSavings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoryGroupSavingsImplCopyWith<_$CategoryGroupSavingsImpl>
      get copyWith =>
          __$$CategoryGroupSavingsImplCopyWithImpl<_$CategoryGroupSavingsImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoryGroupSavingsImplToJson(
      this,
    );
  }
}

abstract class _CategoryGroupSavings implements CategoryGroupSavings {
  const factory _CategoryGroupSavings(
      {required final String groupId,
      required final String groupName,
      required final double spendingLimit,
      required final double totalSpent,
      required final double remaining,
      required final double savingsPercentage}) = _$CategoryGroupSavingsImpl;

  factory _CategoryGroupSavings.fromJson(Map<String, dynamic> json) =
      _$CategoryGroupSavingsImpl.fromJson;

  @override
  String get groupId;
  @override
  String get groupName;
  @override
  double get spendingLimit;
  @override
  double get totalSpent;
  @override
  double get remaining;
  @override
  double get savingsPercentage;

  /// Create a copy of CategoryGroupSavings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoryGroupSavingsImplCopyWith<_$CategoryGroupSavingsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
