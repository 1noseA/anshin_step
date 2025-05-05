// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
      id: json['id'] as String? ?? '',
      goal: json['title'] as String,
      anxiety: json['concern'] as String,
      babySteps: (json['baby_steps'] as List<dynamic>?)
          ?.map((e) => BabyStep.fromJson(e as Map<String, dynamic>))
          .toList(),
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedBy: json['updated_by'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.goal,
      'concern': instance.anxiety,
      'baby_steps': instance.babySteps,
      'displayOrder': instance.displayOrder,
      'isDeleted': instance.isDeleted,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_by': instance.updatedBy,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
