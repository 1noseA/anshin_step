import 'package:freezed_annotation/freezed_annotation.dart';

part 'baby_step.freezed.dart';
part 'baby_step.g.dart';

@freezed
abstract class BabyStep with _$BabyStep {
  const factory BabyStep({
    required String id,
    required String action, // 行動
    required String goalId, // 親ゴールID
    int? displayOrder, // 表示順
    bool? isDone, // 実施済みフラグ
    DateTime? executionDate, // 実行日付
    int? beforeAnxietyScore, // 事前不安得点
    int? afterAnxietyScore, // 事後不安得点
    String? comment, // コメント
    bool? isDeleted, // 論理削除フラグ
    required String createdBy, // レコード登録者
    required DateTime createdAt, // レコード登録日
    required String updatedBy, // レコード更新者
    required DateTime updatedAt, // レコード更新日
  }) = _BabyStep;

  factory BabyStep.fromJson(Map<String, dynamic> json) =>
      _$BabyStepFromJson(json);
}
