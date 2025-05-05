import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:anshin_step/models/baby_step.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

List<BabyStep> _babyStepsFromJson(List<dynamic> json) =>
    json.map((e) => BabyStep.fromJson(e as Map<String, dynamic>)).toList();

List<Map<String, dynamic>> _babyStepsToJson(List<BabyStep>? steps) =>
    steps?.map((e) => e.toJson()).toList() ?? [];

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
    @JsonKey(name: 'created_at') required DateTime createdAt, // レコード登録日
    @JsonKey(name: 'updated_by') required String updatedBy, // レコード更新者
    @JsonKey(name: 'updated_at') required DateTime updatedAt, // レコード更新日
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
