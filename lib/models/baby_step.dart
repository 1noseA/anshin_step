import 'package:freezed_annotation/freezed_annotation.dart';

part 'baby_step.freezed.dart';
part 'baby_step.g.dart';

@freezed
abstract class BabyStep with _$BabyStep {
  const factory BabyStep({
    required String id,
    required String action,
    int? displayOrder,
    bool? isDone,
    DateTime? executionDate,
    int? beforeAnxietyScore,
    int? afterAnxietyScore,
    String? comment,
    bool? isDeleted,
    required String createdBy,
    required DateTime createdAt,
    required String updatedBy,
    required DateTime updatedAt,
  }) = _BabyStep;

  factory BabyStep.fromJson(Map<String, dynamic> json) =>
      _$BabyStepFromJson(json);
}
