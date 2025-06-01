// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Report _$ReportFromJson(Map<String, dynamic> json) => _Report(
      id: json['id'] as String,
      userId: json['userId'] as String,
      anxietyScoreHistory: (json['anxietyScoreHistory'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      anxietyTendency: json['anxietyTendency'] as Map<String, dynamic>,
      effectiveCopingMethods: (json['effectiveCopingMethods'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      comfortingWords: (json['comfortingWords'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      createdBy: json['createdBy'] as String,
      createdAt: _dateTimeFromTimestamp(json['createdAt']),
      updatedBy: json['updatedBy'] as String,
      updatedAt: _dateTimeFromTimestamp(json['updatedAt']),
    );

Map<String, dynamic> _$ReportToJson(_Report instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'anxietyScoreHistory': instance.anxietyScoreHistory,
      'anxietyTendency': instance.anxietyTendency,
      'effectiveCopingMethods': instance.effectiveCopingMethods,
      'comfortingWords': instance.comfortingWords,
      'createdBy': instance.createdBy,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedBy': instance.updatedBy,
      'updatedAt': _dateTimeToJson(instance.updatedAt),
    };
