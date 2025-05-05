// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baby_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BabyStep _$BabyStepFromJson(Map<String, dynamic> json) => _BabyStep(
      id: json['id'] as String,
      action: json['action'] as String,
      goalId: json['goalId'] as String?,
      displayOrder: (json['displayOrder'] as num?)?.toInt(),
      isDone: json['isDone'] as bool?,
      executionDate: json['executionDate'] == null
          ? null
          : DateTime.parse(json['executionDate'] as String),
      beforeAnxietyScore: (json['beforeAnxietyScore'] as num?)?.toInt(),
      afterAnxietyScore: (json['afterAnxietyScore'] as num?)?.toInt(),
      comment: json['comment'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedBy: json['updatedBy'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$BabyStepToJson(_BabyStep instance) => <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'goalId': instance.goalId,
      'displayOrder': instance.displayOrder,
      'isDone': instance.isDone,
      'executionDate': instance.executionDate?.toIso8601String(),
      'beforeAnxietyScore': instance.beforeAnxietyScore,
      'afterAnxietyScore': instance.afterAnxietyScore,
      'comment': instance.comment,
      'isDeleted': instance.isDeleted,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedBy': instance.updatedBy,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
