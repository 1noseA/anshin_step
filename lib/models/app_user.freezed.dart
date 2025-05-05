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
  String get userName; // ニックネーム
  int? get age; // 年齢
  String? get gender; // 性別
  String? get attribute; // 属性
  bool? get hasMentalIllness; // 精神疾患有無
  List<String>? get mentalIllnesses; // 診断名
  String get createdBy; // レコード登録者
  DateTime get createdAt; // レコード登録日
  String get updatedBy; // レコード更新者
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
            (identical(other.hasMentalIllness, hasMentalIllness) ||
                other.hasMentalIllness == hasMentalIllness) &&
            const DeepCollectionEquality()
                .equals(other.mentalIllnesses, mentalIllnesses) &&
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
      hasMentalIllness,
      const DeepCollectionEquality().hash(mentalIllnesses),
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'AppUser(userName: $userName, age: $age, gender: $gender, attribute: $attribute, hasMentalIllness: $hasMentalIllness, mentalIllnesses: $mentalIllnesses, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
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
      String? gender,
      String? attribute,
      bool? hasMentalIllness,
      List<String>? mentalIllnesses,
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
    Object? hasMentalIllness = freezed,
    Object? mentalIllnesses = freezed,
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
              as String?,
      attribute: freezed == attribute
          ? _self.attribute
          : attribute // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMentalIllness: freezed == hasMentalIllness
          ? _self.hasMentalIllness
          : hasMentalIllness // ignore: cast_nullable_to_non_nullable
              as bool?,
      mentalIllnesses: freezed == mentalIllnesses
          ? _self.mentalIllnesses
          : mentalIllnesses // ignore: cast_nullable_to_non_nullable
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
      this.hasMentalIllness,
      final List<String>? mentalIllnesses,
      required this.createdBy,
      required this.createdAt,
      required this.updatedBy,
      required this.updatedAt})
      : _mentalIllnesses = mentalIllnesses;
  factory _AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  @override
  final String userName;
// ニックネーム
  @override
  final int? age;
// 年齢
  @override
  final String? gender;
// 性別
  @override
  final String? attribute;
// 属性
  @override
  final bool? hasMentalIllness;
// 精神疾患有無
  final List<String>? _mentalIllnesses;
// 精神疾患有無
  @override
  List<String>? get mentalIllnesses {
    final value = _mentalIllnesses;
    if (value == null) return null;
    if (_mentalIllnesses is EqualUnmodifiableListView) return _mentalIllnesses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// 診断名
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
            (identical(other.hasMentalIllness, hasMentalIllness) ||
                other.hasMentalIllness == hasMentalIllness) &&
            const DeepCollectionEquality()
                .equals(other._mentalIllnesses, _mentalIllnesses) &&
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
      hasMentalIllness,
      const DeepCollectionEquality().hash(_mentalIllnesses),
      createdBy,
      createdAt,
      updatedBy,
      updatedAt);

  @override
  String toString() {
    return 'AppUser(userName: $userName, age: $age, gender: $gender, attribute: $attribute, hasMentalIllness: $hasMentalIllness, mentalIllnesses: $mentalIllnesses, createdBy: $createdBy, createdAt: $createdAt, updatedBy: $updatedBy, updatedAt: $updatedAt)';
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
      String? gender,
      String? attribute,
      bool? hasMentalIllness,
      List<String>? mentalIllnesses,
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
    Object? hasMentalIllness = freezed,
    Object? mentalIllnesses = freezed,
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
              as String?,
      attribute: freezed == attribute
          ? _self.attribute
          : attribute // ignore: cast_nullable_to_non_nullable
              as String?,
      hasMentalIllness: freezed == hasMentalIllness
          ? _self.hasMentalIllness
          : hasMentalIllness // ignore: cast_nullable_to_non_nullable
              as bool?,
      mentalIllnesses: freezed == mentalIllnesses
          ? _self._mentalIllnesses
          : mentalIllnesses // ignore: cast_nullable_to_non_nullable
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
