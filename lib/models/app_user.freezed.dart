// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {
  String get userName;
  int? get age;
  int? get gender;
  String? get attribute;
  int? get mentalIllness;
  List<String>? get diagnosisName;
  String get createdBy;
  DateTime get createdAt;
  String get updatedBy;
  DateTime get updatedAt;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppUserCopyWith<AppUser> get copyWith =>
      _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppUser &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.attribute, attribute) ||
                other.attribute == attribute) &&
            (identical(other.mentalIllness, mentalIllness) ||
                other.mentalIllness == mentalIllness) &&
            const DeepCollectionEquality()
                .equals(other.diagnosisName, diagnosisName) &&
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
      userName,
      age,
      gender,
      attribute,
      mentalIllness,
      const DeepCollectionEquality().hash(diagnosisName),
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'AppUser(userName: $userName, age: $age, gender: $gender, attribute: $attribute, mentalIllness: $mentalIllness, diagnosisName: $diagnosisName, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res> {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) =
      _$AppUserCopyWithImpl;
  @useResult
  $Res call(
      {String userName,
      int? age,
      int? gender,
      String? attribute,
      int? mentalIllness,
      List<String>? diagnosisName,
      String createdBy,
      DateTime createdAt,
      String updatedBy,
      DateTime updatedAt});
}

/// @nodoc
class _$AppUserCopyWithImpl<$Res> implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? age = freezed,
    Object? gender = freezed,
    Object? attribute = freezed,
    Object? mentalIllness = freezed,
    Object? diagnosisName = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      age: freezed == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      gender: freezed == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as int?,
      attribute: freezed == attribute
          ? _self.attribute
          : attribute // ignore: cast_nullable_to_non_nullable
              as String?,
      mentalIllness: freezed == mentalIllness
          ? _self.mentalIllness
          : mentalIllness // ignore: cast_nullable_to_non_nullable
              as int?,
      diagnosisName: freezed == diagnosisName
          ? _self.diagnosisName
          : diagnosisName // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
class _AppUser implements AppUser {
  const _AppUser(
      {required this.userName,
      this.age,
      this.gender,
      this.attribute,
      this.mentalIllness,
      final List<String>? diagnosisName,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt})
      : _diagnosisName = diagnosisName;
  factory _AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  @override
  final String userName;
  @override
  final int? age;
  @override
  final int? gender;
  @override
  final String? attribute;
  @override
  final int? mentalIllness;
  final List<String>? _diagnosisName;
  @override
  List<String>? get diagnosisName {
    final value = _diagnosisName;
    if (value == null) return null;
    if (_diagnosisName is EqualUnmodifiableListView) return _diagnosisName;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final String updatedBy;
  @override
  final DateTime updatedAt;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AppUserCopyWith<_AppUser> get copyWith =>
      __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AppUserToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AppUser &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.attribute, attribute) ||
                other.attribute == attribute) &&
            (identical(other.mentalIllness, mentalIllness) ||
                other.mentalIllness == mentalIllness) &&
            const DeepCollectionEquality()
                .equals(other._diagnosisName, _diagnosisName) &&
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
      userName,
      age,
      gender,
      attribute,
      mentalIllness,
      const DeepCollectionEquality().hash(_diagnosisName),
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'AppUser(userName: $userName, age: $age, gender: $gender, attribute: $attribute, mentalIllness: $mentalIllness, diagnosisName: $diagnosisName, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) =
      __$AppUserCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String userName,
      int? age,
      int? gender,
      String? attribute,
      int? mentalIllness,
      List<String>? diagnosisName,
      String createdBy,
      DateTime createdAt,
      String updatedBy,
      DateTime updatedAt});
}

/// @nodoc
class __$AppUserCopyWithImpl<$Res> implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

  /// Create a copy of AppUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userName = null,
    Object? age = freezed,
    Object? gender = freezed,
    Object? attribute = freezed,
    Object? mentalIllness = freezed,
    Object? diagnosisName = freezed,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedBy = null,
    Object? updatedAt = null,
  }) {
    return _then(_AppUser(
      userName: null == userName
          ? _self.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      age: freezed == age
          ? _self.age
          : age // ignore: cast_nullable_to_non_nullable
              as int?,
      gender: freezed == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as int?,
      attribute: freezed == attribute
          ? _self.attribute
          : attribute // ignore: cast_nullable_to_non_nullable
              as String?,
      mentalIllness: freezed == mentalIllness
          ? _self.mentalIllness
          : mentalIllness // ignore: cast_nullable_to_non_nullable
              as int?,
      diagnosisName: freezed == diagnosisName
          ? _self._diagnosisName
          : diagnosisName // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
