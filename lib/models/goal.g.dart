// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
      id: json['id'] as String? ?? '',
      goal: json['goal'] as String,
      anxiety: json['anxiety'] as String,
      babySteps: _babyStepsFromJson(json['babySteps'] as List),
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      createdBy: json['created_by'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedBy: json['updated_by'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
      'id': instance.id,
      'goal': instance.goal,
      'anxiety': instance.anxiety,
      'babySteps': _babyStepsToJson(instance.babySteps),
      'displayOrder': instance.displayOrder,
      'isDeleted': instance.isDeleted,
      'created_by': instance.createdBy,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_by': instance.updatedBy,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
