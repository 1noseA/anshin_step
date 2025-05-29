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
      executionDate: _nullableDateTimeFromTimestamp(json['executionDate']),
      beforeAnxietyScore: (json['beforeAnxietyScore'] as num?)?.toInt(),
      afterAnxietyScore: (json['afterAnxietyScore'] as num?)?.toInt(),
      achievementScore: (json['achievementScore'] as num?)?.toInt(),
      physicalData: json['physicalData'] as String?,
      word: json['word'] as String?,
      copingMethod: json['copingMethod'] as String?,
      impression: json['impression'] as String?,
      emotion: json['emotion'] as String?,
      weather: json['weather'] as String?,
      temperature: (json['temperature'] as num?)?.toInt(),
      pressure: (json['pressure'] as num?)?.toInt(),
      lunarAge: (json['lunarAge'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      createdBy: json['createdBy'] as String,
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      updatedBy: json['updatedBy'] as String,
      updatedAt: _dateTimeFromTimestamp(json['updatedAt']),
    );

Map<String, dynamic> _$BabyStepToJson(_BabyStep instance) => <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'goalId': instance.goalId,
      'displayOrder': instance.displayOrder,
      'isDone': instance.isDone,
      'executionDate': _nullableDateTimeToJson(instance.executionDate),
      'beforeAnxietyScore': instance.beforeAnxietyScore,
      'afterAnxietyScore': instance.afterAnxietyScore,
      'achievementScore': instance.achievementScore,
      'physicalData': instance.physicalData,
      'word': instance.word,
      'copingMethod': instance.copingMethod,
      'impression': instance.impression,
      'emotion': instance.emotion,
      'weather': instance.weather,
      'temperature': instance.temperature,
      'pressure': instance.pressure,
      'lunarAge': instance.lunarAge,
      'isDeleted': instance.isDeleted,
      'createdBy': instance.createdBy,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedBy': instance.updatedBy,
      'updatedAt': _dateTimeToJson(instance.updatedAt),
    };
