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
  String? get goalId; // ゴールID
  int? get displayOrder; // 表示順
  bool? get isDone; // 実施済みフラグ
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _nullableDateTimeToJson)
  DateTime? get executionDate; // 実行日付
  int? get beforeAnxietyScore; // 事前不安得点
  int? get afterAnxietyScore; // 事後不安得点
  int? get achievementScore; // 達成度
  String? get physicalData; // 身体情報
  String? get word; // 言葉
  String? get copingMethod; // 対処法
  String? get impression; // 感想
  String? get emotion; // 感情
  String? get weather; // 天気
  int? get temperature; // 気温
  int? get pressure; // 気圧
  int? get lunarAge; // 月齢
  bool? get isDeleted; // 論理削除フラグ
  String get createdBy; // レコード登録者
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
  DateTime get createdAt; // レコード登録日
  String get updatedBy; // レコード更新者
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
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
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.executionDate, executionDate) ||
                other.executionDate == executionDate) &&
            (identical(other.beforeAnxietyScore, beforeAnxietyScore) ||
                other.beforeAnxietyScore == beforeAnxietyScore) &&
            (identical(other.afterAnxietyScore, afterAnxietyScore) ||
                other.afterAnxietyScore == afterAnxietyScore) &&
            (identical(other.achievementScore, achievementScore) ||
                other.achievementScore == achievementScore) &&
            (identical(other.physicalData, physicalData) ||
                other.physicalData == physicalData) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.copingMethod, copingMethod) ||
                other.copingMethod == copingMethod) &&
            (identical(other.impression, impression) ||
                other.impression == impression) &&
            (identical(other.emotion, emotion) || other.emotion == emotion) &&
            (identical(other.weather, weather) || other.weather == weather) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.pressure, pressure) ||
                other.pressure == pressure) &&
            (identical(other.lunarAge, lunarAge) ||
                other.lunarAge == lunarAge) &&
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
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        action,
        goalId,
        displayOrder,
        isDone,
        executionDate,
        beforeAnxietyScore,
        afterAnxietyScore,
        achievementScore,
        physicalData,
        word,
        copingMethod,
        impression,
        emotion,
        weather,
        temperature,
        pressure,
        lunarAge,
        isDeleted,
        createdBy,
        createdAt,
        updatedBy,
        updatedAt
      ]);

  @override
  String toString() {
    return 'BabyStep(id: $id, action: $action, goalId: $goalId, displayOrder: $displayOrder, isDone: $isDone, executionDate: $executionDate, beforeAnxietyScore: $beforeAnxietyScore, afterAnxietyScore: $afterAnxietyScore, achievementScore: $achievementScore, physicalData: $physicalData, word: $word, copingMethod: $copingMethod, impression: $impression, emotion: $emotion, weather: $weather, temperature: $temperature, pressure: $pressure, lunarAge: $lunarAge, isDeleted: $isDeleted, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
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
      String? goalId,
      int? displayOrder,
      bool? isDone,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _nullableDateTimeToJson)
      DateTime? executionDate,
      int? beforeAnxietyScore,
      int? afterAnxietyScore,
      int? achievementScore,
      String? physicalData,
      String? word,
      String? copingMethod,
      String? impression,
      String? emotion,
      String? weather,
      int? temperature,
      int? pressure,
      int? lunarAge,
      bool? isDeleted,
      String createdBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      DateTime createdAt,
      String updatedBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
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
    Object? goalId = freezed,
    Object? displayOrder = freezed,
    Object? isDone = freezed,
    Object? executionDate = freezed,
    Object? beforeAnxietyScore = freezed,
    Object? afterAnxietyScore = freezed,
    Object? achievementScore = freezed,
    Object? physicalData = freezed,
    Object? word = freezed,
    Object? copingMethod = freezed,
    Object? impression = freezed,
    Object? emotion = freezed,
    Object? weather = freezed,
    Object? temperature = freezed,
    Object? pressure = freezed,
    Object? lunarAge = freezed,
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
      goalId: freezed == goalId
          ? _self.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      achievementScore: freezed == achievementScore
          ? _self.achievementScore
          : achievementScore // ignore: cast_nullable_to_non_nullable
              as int?,
      physicalData: freezed == physicalData
          ? _self.physicalData
          : physicalData // ignore: cast_nullable_to_non_nullable
              as String?,
      word: freezed == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String?,
      copingMethod: freezed == copingMethod
          ? _self.copingMethod
          : copingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      impression: freezed == impression
          ? _self.impression
          : impression // ignore: cast_nullable_to_non_nullable
              as String?,
      emotion: freezed == emotion
          ? _self.emotion
          : emotion // ignore: cast_nullable_to_non_nullable
              as String?,
      weather: freezed == weather
          ? _self.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _self.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as int?,
      pressure: freezed == pressure
          ? _self.pressure
          : pressure // ignore: cast_nullable_to_non_nullable
              as int?,
      lunarAge: freezed == lunarAge
          ? _self.lunarAge
          : lunarAge // ignore: cast_nullable_to_non_nullable
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
class _BabyStep implements BabyStep {
  const _BabyStep(
      {required this.id,
      required this.action,
      this.goalId,
      this.displayOrder,
      this.isDone,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _nullableDateTimeToJson)
      this.executionDate,
      this.beforeAnxietyScore,
      this.afterAnxietyScore,
      this.achievementScore,
      this.physicalData,
      this.word,
      this.copingMethod,
      this.impression,
      this.emotion,
      this.weather,
      this.temperature,
      this.pressure,
      this.lunarAge,
      this.isDeleted,
      required this.createdBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      required this.createdAt,
      required this.updatedBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      required this.updatedAt});
  factory _BabyStep.fromJson(Map<String, dynamic> json) =>
      _$BabyStepFromJson(json);

  @override
  final String id;
  @override
  final String action;
// 行動
  @override
  final String? goalId;
// ゴールID
  @override
  final int? displayOrder;
// 表示順
  @override
  final bool? isDone;
// 実施済みフラグ
  @override
  @JsonKey(
      fromJson: _nullableDateTimeFromTimestamp, toJson: _nullableDateTimeToJson)
  final DateTime? executionDate;
// 実行日付
  @override
  final int? beforeAnxietyScore;
// 事前不安得点
  @override
  final int? afterAnxietyScore;
// 事後不安得点
  @override
  final int? achievementScore;
// 達成度
  @override
  final String? physicalData;
// 身体情報
  @override
  final String? word;
// 言葉
  @override
  final String? copingMethod;
// 対処法
  @override
  final String? impression;
// 感想
  @override
  final String? emotion;
// 感情
  @override
  final String? weather;
// 天気
  @override
  final int? temperature;
// 気温
  @override
  final int? pressure;
// 気圧
  @override
  final int? lunarAge;
// 月齢
  @override
  final bool? isDeleted;
// 論理削除フラグ
  @override
  final String createdBy;
// レコード登録者
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
  final DateTime createdAt;
// レコード登録日
  @override
  final String updatedBy;
// レコード更新者
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
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
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.displayOrder, displayOrder) ||
                other.displayOrder == displayOrder) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.executionDate, executionDate) ||
                other.executionDate == executionDate) &&
            (identical(other.beforeAnxietyScore, beforeAnxietyScore) ||
                other.beforeAnxietyScore == beforeAnxietyScore) &&
            (identical(other.afterAnxietyScore, afterAnxietyScore) ||
                other.afterAnxietyScore == afterAnxietyScore) &&
            (identical(other.achievementScore, achievementScore) ||
                other.achievementScore == achievementScore) &&
            (identical(other.physicalData, physicalData) ||
                other.physicalData == physicalData) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.copingMethod, copingMethod) ||
                other.copingMethod == copingMethod) &&
            (identical(other.impression, impression) ||
                other.impression == impression) &&
            (identical(other.emotion, emotion) || other.emotion == emotion) &&
            (identical(other.weather, weather) || other.weather == weather) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.pressure, pressure) ||
                other.pressure == pressure) &&
            (identical(other.lunarAge, lunarAge) ||
                other.lunarAge == lunarAge) &&
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
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        action,
        goalId,
        displayOrder,
        isDone,
        executionDate,
        beforeAnxietyScore,
        afterAnxietyScore,
        achievementScore,
        physicalData,
        word,
        copingMethod,
        impression,
        emotion,
        weather,
        temperature,
        pressure,
        lunarAge,
        isDeleted,
        createdBy,
        createdAt,
        updatedBy,
        updatedAt
      ]);

  @override
  String toString() {
    return 'BabyStep(id: $id, action: $action, goalId: $goalId, displayOrder: $displayOrder, isDone: $isDone, executionDate: $executionDate, beforeAnxietyScore: $beforeAnxietyScore, afterAnxietyScore: $afterAnxietyScore, achievementScore: $achievementScore, physicalData: $physicalData, word: $word, copingMethod: $copingMethod, impression: $impression, emotion: $emotion, weather: $weather, temperature: $temperature, pressure: $pressure, lunarAge: $lunarAge, isDeleted: $isDeleted, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
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
      String? goalId,
      int? displayOrder,
      bool? isDone,
      @JsonKey(
          fromJson: _nullableDateTimeFromTimestamp,
          toJson: _nullableDateTimeToJson)
      DateTime? executionDate,
      int? beforeAnxietyScore,
      int? afterAnxietyScore,
      int? achievementScore,
      String? physicalData,
      String? word,
      String? copingMethod,
      String? impression,
      String? emotion,
      String? weather,
      int? temperature,
      int? pressure,
      int? lunarAge,
      bool? isDeleted,
      String createdBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      DateTime createdAt,
      String updatedBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
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
    Object? goalId = freezed,
    Object? displayOrder = freezed,
    Object? isDone = freezed,
    Object? executionDate = freezed,
    Object? beforeAnxietyScore = freezed,
    Object? afterAnxietyScore = freezed,
    Object? achievementScore = freezed,
    Object? physicalData = freezed,
    Object? word = freezed,
    Object? copingMethod = freezed,
    Object? impression = freezed,
    Object? emotion = freezed,
    Object? weather = freezed,
    Object? temperature = freezed,
    Object? pressure = freezed,
    Object? lunarAge = freezed,
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
      goalId: freezed == goalId
          ? _self.goalId
          : goalId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      achievementScore: freezed == achievementScore
          ? _self.achievementScore
          : achievementScore // ignore: cast_nullable_to_non_nullable
              as int?,
      physicalData: freezed == physicalData
          ? _self.physicalData
          : physicalData // ignore: cast_nullable_to_non_nullable
              as String?,
      word: freezed == word
          ? _self.word
          : word // ignore: cast_nullable_to_non_nullable
              as String?,
      copingMethod: freezed == copingMethod
          ? _self.copingMethod
          : copingMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      impression: freezed == impression
          ? _self.impression
          : impression // ignore: cast_nullable_to_non_nullable
              as String?,
      emotion: freezed == emotion
          ? _self.emotion
          : emotion // ignore: cast_nullable_to_non_nullable
              as String?,
      weather: freezed == weather
          ? _self.weather
          : weather // ignore: cast_nullable_to_non_nullable
              as String?,
      temperature: freezed == temperature
          ? _self.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as int?,
      pressure: freezed == pressure
          ? _self.pressure
          : pressure // ignore: cast_nullable_to_non_nullable
              as int?,
      lunarAge: freezed == lunarAge
          ? _self.lunarAge
          : lunarAge // ignore: cast_nullable_to_non_nullable
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
