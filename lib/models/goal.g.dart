// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
      goal: json['goal'] as String,
      anxiety: json['anxiety'] as String,
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedBy: json['updatedBy'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
      'goal': instance.goal,
      'anxiety': instance.anxiety,
      'displayOrder': instance.displayOrder,
      'isDeleted': instance.isDeleted,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
