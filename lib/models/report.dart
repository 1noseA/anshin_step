import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'report.freezed.dart';
part 'report.g.dart';

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  if (value is DateTime) {
    return value;
  }
  throw Exception('Invalid date format');
}

String _dateTimeToJson(DateTime date) => date.toIso8601String();

@freezed
abstract class Report with _$Report {
  const factory Report({
    required String id,
    required String userId, // ユーザーID

    // 分析結果
    required List<Map<String, dynamic>> anxietyScoreHistory, // 不安得点の推移
    required Map<String, dynamic> anxietyTendency, // 不安傾向（天気、気温、気圧、月齢との関連）
    required List<String> effectiveCopingMethods, // 効果的な対処法
    required List<String> comfortingWords, // 安心につながる言葉

    // メタデータ
    required String createdBy,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
    required DateTime createdAt,
    required String updatedBy,
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
    required DateTime updatedAt,
  }) = _Report;

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
}
