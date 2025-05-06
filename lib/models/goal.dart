import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:anshin_step/models/baby_step.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

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

List<BabyStep> _babyStepsFromJson(List<dynamic> json) {
  if (json.isEmpty) return [];
  return json.map((e) {
    if (e is Map<String, dynamic>) {
      return BabyStep.fromJson(e);
    }
    throw Exception('Invalid baby step data format');
  }).toList();
}

List<Map<String, dynamic>> _babyStepsToJson(List<BabyStep>? steps) {
  if (steps == null) return [];
  return steps.map((e) => e.toJson()).toList();
}

@Freezed(fromJson: true, toJson: true)
abstract class Goal with _$Goal {
  const factory Goal({
    @JsonKey(name: 'id', defaultValue: '') required String id,
    @JsonKey(name: 'goal') required String goal, // やりたいこと
    @JsonKey(name: 'anxiety') required String anxiety, // 不安なこと
    @JsonKey(
      name: 'babySteps',
      fromJson: _babyStepsFromJson,
      toJson: _babyStepsToJson,
    )
    List<BabyStep>? babySteps,
    int? displayOrder, // 表示順
    bool? isDeleted, // 論理削除フラグ
    @JsonKey(name: 'created_by') required String createdBy, // レコード登録者
    @JsonKey(
        name: 'created_at',
        fromJson: _dateTimeFromTimestamp,
        toJson: _dateTimeToJson)
    required DateTime createdAt, // レコード登録日
    @JsonKey(name: 'updated_by') required String updatedBy, // レコード更新者
    @JsonKey(
        name: 'updated_at',
        fromJson: _dateTimeFromTimestamp,
        toJson: _dateTimeToJson)
    required DateTime updatedAt, // レコード更新日
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
