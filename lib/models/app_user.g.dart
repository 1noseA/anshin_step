// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
      userName: json['userName'] as String,
      age: (json['age'] as num?)?.toInt(),
      gender: json['gender'] as String?,
      attribute: json['attribute'] as String?,
      hasMentalIllness: json['hasMentalIllness'] as bool?,
      mentalIllnesses: (json['mentalIllnesses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedBy: json['updatedBy'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
      'userName': instance.userName,
      'age': instance.age,
      'gender': instance.gender,
      'attribute': instance.attribute,
      'hasMentalIllness': instance.hasMentalIllness,
      'mentalIllnesses': instance.mentalIllnesses,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
