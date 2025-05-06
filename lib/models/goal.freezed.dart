// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Goal {
  @JsonKey(name: 'id', defaultValue: '')
  String get id;
  @JsonKey(name: 'goal')
  String get goal; // やりたいこと
  @JsonKey(name: 'anxiety')
  String get anxiety; // 不安なこと
  @JsonKey(
      name: 'babySteps', fromJson: _babyStepsFromJson, toJson: _babyStepsToJson)
  List<BabyStep>? get babySteps;
  int? get displayOrder; // 表示順
  bool? get isDeleted; // 論理削除フラグ
  @JsonKey(name: 'created_by')
  String get createdBy; // レコード登録者
  @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromTimestamp,
      toJson: _dateTimeToJson)
  DateTime get createdAt; // レコード登録日
  @JsonKey(name: 'updated_by')
  String get updatedBy; // レコード更新者
  @JsonKey(
      name: 'updated_at',
      fromJson: _dateTimeFromTimestamp,
      toJson: _dateTimeToJson)
  DateTime get updatedAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalCopyWith<Goal> get copyWith =>
      _$GoalCopyWithImpl<Goal>(this as Goal, _$identity);

  /// Serializes this Goal to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Goal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.anxiety, anxiety) || other.anxiety == anxiety) &&
            const DeepCollectionEquality().equals(other.babySteps, babySteps) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      goal,
      anxiety,
      const DeepCollectionEquality().hash(babySteps),
      displayOrder,
      isDeleted,
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'Goal(id: $id, goal: $goal, anxiety: $anxiety, babySteps: $babySteps, displayOrder: $displayOrder, isDeleted: $isDeleted, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $GoalCopyWith<$Res> {
  factory $GoalCopyWith(Goal value, $Res Function(Goal) _then) =
      _$GoalCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id', defaultValue: '') String id,
      @JsonKey(name: 'goal') String goal,
      @JsonKey(name: 'anxiety') String anxiety,
      @JsonKey(
          name: 'babySteps',
          fromJson: _babyStepsFromJson,
          toJson: _babyStepsToJson)
      List<BabyStep>? babySteps,
      int? displayOrder,
      bool? isDeleted,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromTimestamp,
          toJson: _dateTimeToJson)
      DateTime createdAt,
      @JsonKey(name: 'updated_by') String updatedBy,
      @JsonKey(
          name: 'updated_at',
          fromJson: _dateTimeFromTimestamp,
          toJson: _dateTimeToJson)
      DateTime updatedAt});
}

/// @nodoc
class _$GoalCopyWithImpl<$Res> implements $GoalCopyWith<$Res> {
  _$GoalCopyWithImpl(this._self, this._then);

  final Goal _self;
  final $Res Function(Goal) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? goal = null,
    Object? anxiety = null,
    Object? babySteps = freezed,
    Object? displayOrder = freezed,
    Object? isDeleted = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      anxiety: null == anxiety
          ? _self.anxiety
          : anxiety // ignore: cast_nullable_to_non_nullable
              as String,
      babySteps: freezed == babySteps
          ? _self.babySteps
          : babySteps // ignore: cast_nullable_to_non_nullable
              as List<BabyStep>?,
      displayOrder: freezed == displayOrder
          ? _self.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isDeleted: freezed == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: null == updatedBy
          ? _self.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Goal implements Goal {
  const _Goal(
      {@JsonKey(name: 'id', defaultValue: '') required this.id,
      @JsonKey(name: 'goal') required this.goal,
      @JsonKey(name: 'anxiety') required this.anxiety,
      @JsonKey(
          name: 'babySteps',
          fromJson: _babyStepsFromJson,
          toJson: _babyStepsToJson)
      final List<BabyStep>? babySteps,
      this.displayOrder,
      this.isDeleted,
      @JsonKey(name: 'created_by') required this.createdBy,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromTimestamp,
          toJson: _dateTimeToJson)
      required this.createdAt,
      @JsonKey(name: 'updated_by') required this.updatedBy,
      @JsonKey(
          name: 'updated_at',
          fromJson: _dateTimeFromTimestamp,
          toJson: _dateTimeToJson)
      required this.updatedAt})
      : _babySteps = babySteps;
  factory _Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  @override
  @JsonKey(name: 'id', defaultValue: '')
  final String id;
  @override
  @JsonKey(name: 'goal')
  final String goal;
// やりたいこと
  @override
  @JsonKey(name: 'anxiety')
  final String anxiety;
// 不安なこと
  final List<BabyStep>? _babySteps;
// 不安なこと
  @override
  @JsonKey(
      name: 'babySteps', fromJson: _babyStepsFromJson, toJson: _babyStepsToJson)
  List<BabyStep>? get babySteps {
    final value = _babySteps;
    if (value == null) return null;
    if (_babySteps is EqualUnmodifiableListView) return _babySteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? displayOrder;
// 表示順
  @override
  final bool? isDeleted;
// 論理削除フラグ
  @override
  @JsonKey(name: 'created_by')
  final String createdBy;
// レコード登録者
  @override
  @JsonKey(
      name: 'created_at',
      fromJson: _dateTimeFromTimestamp,
      toJson: _dateTimeToJson)
  final DateTime createdAt;
// レコード登録日
  @override
  @JsonKey(name: 'updated_by')
  final String updatedBy;
// レコード更新者
  @override
  @JsonKey(
      name: 'updated_at',
      fromJson: _dateTimeFromTimestamp,
      toJson: _dateTimeToJson)
  final DateTime updatedAt;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalCopyWith<_Goal> get copyWith =>
      __$GoalCopyWithImpl<_Goal>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GoalToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Goal &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.anxiety, anxiety) || other.anxiety == anxiety) &&
            const DeepCollectionEquality()
                .equals(other._babySteps, _babySteps) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedBy, updatedBy) ||
                other.updatedBy == updatedBy) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      goal,
      anxiety,
      const DeepCollectionEquality().hash(_babySteps),
      displayOrder,
      isDeleted,
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'Goal(id: $id, goal: $goal, anxiety: $anxiety, babySteps: $babySteps, displayOrder: $displayOrder, isDeleted: $isDeleted, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$GoalCopyWith<$Res> implements $GoalCopyWith<$Res> {
  factory _$GoalCopyWith(_Goal value, $Res Function(_Goal) _then) =
      __$GoalCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id', defaultValue: '') String id,
      @JsonKey(name: 'goal') String goal,
      @JsonKey(name: 'anxiety') String anxiety,
      @JsonKey(
          name: 'babySteps',
          fromJson: _babyStepsFromJson,
          toJson: _babyStepsToJson)
      List<BabyStep>? babySteps,
      int? displayOrder,
      bool? isDeleted,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(
          name: 'created_at',
          fromJson: _dateTimeFromTimestamp,
          toJson: _dateTimeToJson)
      DateTime createdAt,
      @JsonKey(name: 'updated_by') String updatedBy,
      @JsonKey(
          name: 'updated_at',
          fromJson: _dateTimeFromTimestamp,
          toJson: _dateTimeToJson)
      DateTime updatedAt});
}

/// @nodoc
class __$GoalCopyWithImpl<$Res> implements _$GoalCopyWith<$Res> {
  __$GoalCopyWithImpl(this._self, this._then);

  final _Goal _self;
  final $Res Function(_Goal) _then;

  /// Create a copy of Goal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? goal = null,
    Object? anxiety = null,
    Object? babySteps = freezed,
    Object? displayOrder = freezed,
    Object? isDeleted = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
  }) {
    return _then(_Goal(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      goal: null == goal
          ? _self.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as String,
      anxiety: null == anxiety
          ? _self.anxiety
          : anxiety // ignore: cast_nullable_to_non_nullable
              as String,
      babySteps: freezed == babySteps
          ? _self._babySteps
          : babySteps // ignore: cast_nullable_to_non_nullable
              as List<BabyStep>?,
      displayOrder: freezed == displayOrder
          ? _self.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isDeleted: freezed == isDeleted
          ? _self.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool?,
      createdBy: null == createdBy
          ? _self.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedBy: null == updatedBy
          ? _self.updatedBy
          : updatedBy // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
