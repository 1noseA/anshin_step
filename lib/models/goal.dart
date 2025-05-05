import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:anshin_step/models/baby_step.dart';

part 'goal.freezed.dart';
part 'goal.g.dart';

@Freezed(fromJson: true, toJson: true)
abstract class Goal with _$Goal {
  const factory Goal({
    @JsonKey(name: 'id', defaultValue: '') required String id,
    @JsonKey(name: 'title') required String goal, // やりたいこと
    @JsonKey(name: 'concern') required String anxiety, // 不安なこと
    @JsonKey(name: 'baby_steps') List<BabyStep>? babySteps,
    int? displayOrder, // 表示順
    bool? isDeleted, // 論理削除フラグ
    @JsonKey(name: 'created_by') required String createdBy, // レコード登録者
    @JsonKey(name: 'created_at') required DateTime createdAt, // レコード登録日
    @JsonKey(name: 'updated_by') required String updatedBy, // レコード更新者
    @JsonKey(name: 'updated_at') required DateTime updatedAt, // レコード更新日
  }) = _Goal;

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);
}
