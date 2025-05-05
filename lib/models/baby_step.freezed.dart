// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'baby_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BabyStep {
  String get id;
  String get action; // 行動
  int? get displayOrder; // 表示順
  bool? get isDone; // 実施済みフラグ
  DateTime? get executionDate; // 実行日付
  int? get beforeAnxietyScore; // 事前不安得点
  int? get afterAnxietyScore; // 事後不安得点
  String? get comment; // コメント
  bool? get isDeleted; // 論理削除フラグ
  String get createdBy; // レコード登録者
  DateTime get createdAt; // レコード登録日
  String get updatedBy; // レコード更新者
  DateTime get updatedAt;

  /// Create a copy of BabyStep
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BabyStepCopyWith<BabyStep> get copyWith =>
      _$BabyStepCopyWithImpl<BabyStep>(this as BabyStep, _$identity);

  /// Serializes this BabyStep to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BabyStep &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.executionDate, executionDate) ||
                other.executionDate == executionDate) &&
            (identical(other.beforeAnxietyScore, beforeAnxietyScore) ||
                other.beforeAnxietyScore == beforeAnxietyScore) &&
            (identical(other.afterAnxietyScore, afterAnxietyScore) ||
                other.afterAnxietyScore == afterAnxietyScore) &&
            (identical(other.comment, comment) || other.comment == comment) &&
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
      action,
      displayOrder,
      isDone,
      executionDate,
      beforeAnxietyScore,
      afterAnxietyScore,
      comment,
      isDeleted,
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'BabyStep(id: $id, action: $action, displayOrder: $displayOrder, isDone: $isDone, executionDate: $executionDate, beforeAnxietyScore: $beforeAnxietyScore, afterAnxietyScore: $afterAnxietyScore, comment: $comment, isDeleted: $isDeleted, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $BabyStepCopyWith<$Res> {
  factory $BabyStepCopyWith(BabyStep value, $Res Function(BabyStep) _then) =
      _$BabyStepCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String action,
      int? displayOrder,
      bool? isDone,
      DateTime? executionDate,
      int? beforeAnxietyScore,
      int? afterAnxietyScore,
      String? comment,
      bool? isDeleted,
      String createdBy,
      DateTime createdAt,
      String updatedBy,
      DateTime updatedAt});
}

/// @nodoc
class _$BabyStepCopyWithImpl<$Res> implements $BabyStepCopyWith<$Res> {
  _$BabyStepCopyWithImpl(this._self, this._then);

  final BabyStep _self;
  final $Res Function(BabyStep) _then;

  /// Create a copy of BabyStep
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? displayOrder = freezed,
    Object? isDone = freezed,
    Object? executionDate = freezed,
    Object? beforeAnxietyScore = freezed,
    Object? afterAnxietyScore = freezed,
    Object? comment = freezed,
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
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      displayOrder: freezed == displayOrder
          ? _self.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isDone: freezed == isDone
          ? _self.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      executionDate: freezed == executionDate
          ? _self.executionDate
          : executionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beforeAnxietyScore: freezed == beforeAnxietyScore
          ? _self.beforeAnxietyScore
          : beforeAnxietyScore // ignore: cast_nullable_to_non_nullable
              as int?,
      afterAnxietyScore: freezed == afterAnxietyScore
          ? _self.afterAnxietyScore
          : afterAnxietyScore // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _BabyStep implements BabyStep {
  const _BabyStep(
      {required this.id,
      required this.action,
      this.displayOrder,
      this.isDone,
      this.executionDate,
      this.beforeAnxietyScore,
      this.afterAnxietyScore,
      this.comment,
      this.isDeleted,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt});
  factory _BabyStep.fromJson(Map<String, dynamic> json) =>
      _$BabyStepFromJson(json);

  @override
  final String id;
  @override
  final String action;
// 行動
  @override
  final int? displayOrder;
// 表示順
  @override
  final bool? isDone;
// 実施済みフラグ
  @override
  final DateTime? executionDate;
// 実行日付
  @override
  final int? beforeAnxietyScore;
// 事前不安得点
  @override
  final int? afterAnxietyScore;
// 事後不安得点
  @override
  final String? comment;
// コメント
  @override
  final bool? isDeleted;
// 論理削除フラグ
  @override
  final String createdBy;
// レコード登録者
  @override
  final DateTime createdAt;
// レコード登録日
  @override
  final String updatedBy;
// レコード更新者
  @override
  final DateTime updatedAt;

  /// Create a copy of BabyStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BabyStepCopyWith<_BabyStep> get copyWith =>
      __$BabyStepCopyWithImpl<_BabyStep>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BabyStepToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BabyStep &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.executionDate, executionDate) ||
                other.executionDate == executionDate) &&
            (identical(other.beforeAnxietyScore, beforeAnxietyScore) ||
                other.beforeAnxietyScore == beforeAnxietyScore) &&
            (identical(other.afterAnxietyScore, afterAnxietyScore) ||
                other.afterAnxietyScore == afterAnxietyScore) &&
            (identical(other.comment, comment) || other.comment == comment) &&
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
      action,
      displayOrder,
      isDone,
      executionDate,
      beforeAnxietyScore,
      afterAnxietyScore,
      comment,
      isDeleted,
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'BabyStep(id: $id, action: $action, displayOrder: $displayOrder, isDone: $isDone, executionDate: $executionDate, beforeAnxietyScore: $beforeAnxietyScore, afterAnxietyScore: $afterAnxietyScore, comment: $comment, isDeleted: $isDeleted, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$BabyStepCopyWith<$Res>
    implements $BabyStepCopyWith<$Res> {
  factory _$BabyStepCopyWith(_BabyStep value, $Res Function(_BabyStep) _then) =
      __$BabyStepCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String action,
      int? displayOrder,
      bool? isDone,
      DateTime? executionDate,
      int? beforeAnxietyScore,
      int? afterAnxietyScore,
      String? comment,
      bool? isDeleted,
      String createdBy,
      DateTime createdAt,
      String updatedBy,
      DateTime updatedAt});
}

/// @nodoc
class __$BabyStepCopyWithImpl<$Res> implements _$BabyStepCopyWith<$Res> {
  __$BabyStepCopyWithImpl(this._self, this._then);

  final _BabyStep _self;
  final $Res Function(_BabyStep) _then;

  /// Create a copy of BabyStep
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? action = null,
    Object? displayOrder = freezed,
    Object? isDone = freezed,
    Object? executionDate = freezed,
    Object? beforeAnxietyScore = freezed,
    Object? afterAnxietyScore = freezed,
    Object? comment = freezed,
    Object? isDeleted = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
  }) {
    return _then(_BabyStep(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _self.action
          : action // ignore: cast_nullable_to_non_nullable
              as String,
      displayOrder: freezed == displayOrder
          ? _self.displayOrder
          : displayOrder // ignore: cast_nullable_to_non_nullable
              as int?,
      isDone: freezed == isDone
          ? _self.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool?,
      executionDate: freezed == executionDate
          ? _self.executionDate
          : executionDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      beforeAnxietyScore: freezed == beforeAnxietyScore
          ? _self.beforeAnxietyScore
          : beforeAnxietyScore // ignore: cast_nullable_to_non_nullable
              as int?,
      afterAnxietyScore: freezed == afterAnxietyScore
          ? _self.afterAnxietyScore
          : afterAnxietyScore // ignore: cast_nullable_to_non_nullable
              as int?,
      comment: freezed == comment
          ? _self.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
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
