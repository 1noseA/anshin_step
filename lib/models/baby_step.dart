import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'baby_step.freezed.dart';
part 'baby_step.g.dart';

DateTime? _nullableDateTimeFromTimestamp(dynamic value) {
  if (value == null) return null;
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  throw Exception('Invalid date format');
}

DateTime _dateTimeFromTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }
  if (value is String) {
    return DateTime.parse(value);
  }
  throw Exception('Invalid date format');
}

String? _nullableDateTimeToJson(DateTime? date) => date?.toIso8601String();
String _dateTimeToJson(DateTime date) => date.toIso8601String();

@freezed
abstract class BabyStep with _$BabyStep {
  const factory BabyStep({
    required String id,
    required String action, // 行動
    String? goalId, // ゴールID
    int? displayOrder, // 表示順
    bool? isDone, // 実施済みフラグ
    @JsonKey(
        fromJson: _nullableDateTimeFromTimestamp,
        toJson: _nullableDateTimeToJson)
    DateTime? executionDate, // 実行日付
    int? beforeAnxietyScore, // 事前不安得点
    int? afterAnxietyScore, // 事後不安得点
    int? achievementScore, // 達成度
    String? physicalData, // 身体情報
    String? word, // 言葉
    String? copingMethod, // 対処法
    String? impression, // 感想
    String? emotion, // 感情
    String? weather, // 天気
    int? temperature, // 気温
    int? pressure, // 気圧
    int? lunarAge, // 月齢
    bool? isDeleted, // 論理削除フラグ
    required String createdBy, // レコード登録者
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
    required DateTime createdAt, // レコード登録日
    required String updatedBy, // レコード更新者
    @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToJson)
    required DateTime updatedAt, // レコード更新日
  }) = _BabyStep;

  factory BabyStep.fromJson(Map<String, dynamic> json) =>
      _$BabyStepFromJson(json);
}
