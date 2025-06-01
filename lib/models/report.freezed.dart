// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Report {
  String get id;
  String get userId; // ユーザーID
// 分析結果
  List<Map<String, dynamic>> get anxietyScoreHistory; // 不安得点の推移
  Map<String, dynamic> get anxietyTendency; // 不安傾向（天気、気温、気圧、月齢との関連）
  List<String> get effectiveCopingMethods; // 効果的な対処法
  List<String> get comfortingWords; // 安心につながる言葉
// メタデータ
  String get createdBy;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
  DateTime get createdAt;
  String get updatedBy;
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
  DateTime get updatedAt;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReportCopyWith<Report> get copyWith =>
      _$ReportCopyWithImpl<Report>(this as Report, _$identity);

  /// Serializes this Report to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Report &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other.anxietyScoreHistory, anxietyScoreHistory) &&
            const DeepCollectionEquality()
                .equals(other.anxietyTendency, anxietyTendency) &&
            const DeepCollectionEquality()
                .equals(other.effectiveCopingMethods, effectiveCopingMethods) &&
            const DeepCollectionEquality()
                .equals(other.comfortingWords, comfortingWords) &&
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
      userId,
      const DeepCollectionEquality().hash(anxietyScoreHistory),
      const DeepCollectionEquality().hash(anxietyTendency),
      const DeepCollectionEquality().hash(effectiveCopingMethods),
      const DeepCollectionEquality().hash(comfortingWords),
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'Report(id: $id, userId: $userId, anxietyScoreHistory: $anxietyScoreHistory, anxietyTendency: $anxietyTendency, effectiveCopingMethods: $effectiveCopingMethods, comfortingWords: $comfortingWords, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ReportCopyWith<$Res> {
  factory $ReportCopyWith(Report value, $Res Function(Report) _then) =
      _$ReportCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      List<Map<String, dynamic>> anxietyScoreHistory,
      Map<String, dynamic> anxietyTendency,
      List<String> effectiveCopingMethods,
      List<String> comfortingWords,
      String createdBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      DateTime createdAt,
      String updatedBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      DateTime updatedAt});
}

/// @nodoc
class _$ReportCopyWithImpl<$Res> implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._self, this._then);

  final Report _self;
  final $Res Function(Report) _then;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? anxietyScoreHistory = null,
    Object? anxietyTendency = null,
    Object? effectiveCopingMethods = null,
    Object? comfortingWords = null,
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
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      anxietyScoreHistory: null == anxietyScoreHistory
          ? _self.anxietyScoreHistory
          : anxietyScoreHistory // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      anxietyTendency: null == anxietyTendency
          ? _self.anxietyTendency
          : anxietyTendency // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      effectiveCopingMethods: null == effectiveCopingMethods
          ? _self.effectiveCopingMethods
          : effectiveCopingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comfortingWords: null == comfortingWords
          ? _self.comfortingWords
          : comfortingWords // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
class _Report implements Report {
  const _Report(
      {required this.id,
      required this.userId,
      required final List<Map<String, dynamic>> anxietyScoreHistory,
      required final Map<String, dynamic> anxietyTendency,
      required final List<String> effectiveCopingMethods,
      required final List<String> comfortingWords,
      required this.createdBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      required this.createdAt,
      required this.updatedBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      required this.updatedAt})
      : _anxietyScoreHistory = anxietyScoreHistory,
        _anxietyTendency = anxietyTendency,
        _effectiveCopingMethods = effectiveCopingMethods,
        _comfortingWords = comfortingWords;
  factory _Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  @override
  final String id;
  @override
  final String userId;
// ユーザーID
// 分析結果
  final List<Map<String, dynamic>> _anxietyScoreHistory;
// ユーザーID
// 分析結果
  @override
  List<Map<String, dynamic>> get anxietyScoreHistory {
    if (_anxietyScoreHistory is EqualUnmodifiableListView)
      return _anxietyScoreHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_anxietyScoreHistory);
  }

// 不安得点の推移
  final Map<String, dynamic> _anxietyTendency;
// 不安得点の推移
  @override
  Map<String, dynamic> get anxietyTendency {
    if (_anxietyTendency is EqualUnmodifiableMapView) return _anxietyTendency;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_anxietyTendency);
  }

// 不安傾向（天気、気温、気圧、月齢との関連）
  final List<String> _effectiveCopingMethods;
// 不安傾向（天気、気温、気圧、月齢との関連）
  @override
  List<String> get effectiveCopingMethods {
    if (_effectiveCopingMethods is EqualUnmodifiableListView)
      return _effectiveCopingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_effectiveCopingMethods);
  }

// 効果的な対処法
  final List<String> _comfortingWords;
// 効果的な対処法
  @override
  List<String> get comfortingWords {
    if (_comfortingWords is EqualUnmodifiableListView) return _comfortingWords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comfortingWords);
  }

// 安心につながる言葉
// メタデータ
  @override
  final String createdBy;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
  final DateTime createdAt;
  @override
  final String updatedBy;
  @override
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
  final DateTime updatedAt;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReportCopyWith<_Report> get copyWith =>
      __$ReportCopyWithImpl<_Report>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReportToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Report &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality()
                .equals(other._anxietyScoreHistory, _anxietyScoreHistory) &&
            const DeepCollectionEquality()
                .equals(other._anxietyTendency, _anxietyTendency) &&
            const DeepCollectionEquality().equals(
                other._effectiveCopingMethods, _effectiveCopingMethods) &&
            const DeepCollectionEquality()
                .equals(other._comfortingWords, _comfortingWords) &&
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
      userId,
      const DeepCollectionEquality().hash(_anxietyScoreHistory),
      const DeepCollectionEquality().hash(_anxietyTendency),
      const DeepCollectionEquality().hash(_effectiveCopingMethods),
      const DeepCollectionEquality().hash(_comfortingWords),
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'Report(id: $id, userId: $userId, anxietyScoreHistory: $anxietyScoreHistory, anxietyTendency: $anxietyTendency, effectiveCopingMethods: $effectiveCopingMethods, comfortingWords: $comfortingWords, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ReportCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$ReportCopyWith(_Report value, $Res Function(_Report) _then) =
      __$ReportCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      List<Map<String, dynamic>> anxietyScoreHistory,
      Map<String, dynamic> anxietyTendency,
      List<String> effectiveCopingMethods,
      List<String> comfortingWords,
      String createdBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      DateTime createdAt,
      String updatedBy,
      @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
      DateTime updatedAt});
}

/// @nodoc
class __$ReportCopyWithImpl<$Res> implements _$ReportCopyWith<$Res> {
  __$ReportCopyWithImpl(this._self, this._then);

  final _Report _self;
  final $Res Function(_Report) _then;

  /// Create a copy of Report
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? anxietyScoreHistory = null,
    Object? anxietyTendency = null,
    Object? effectiveCopingMethods = null,
    Object? comfortingWords = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
  }) {
    return _then(_Report(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      anxietyScoreHistory: null == anxietyScoreHistory
          ? _self._anxietyScoreHistory
          : anxietyScoreHistory // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      anxietyTendency: null == anxietyTendency
          ? _self._anxietyTendency
          : anxietyTendency // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      effectiveCopingMethods: null == effectiveCopingMethods
          ? _self._effectiveCopingMethods
          : effectiveCopingMethods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comfortingWords: null == comfortingWords
          ? _self._comfortingWords
          : comfortingWords // ignore: cast_nullable_to_non_nullable
              as List<String>,
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
