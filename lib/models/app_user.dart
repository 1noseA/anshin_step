import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String userName, // ニックネーム
    int? age, // 年齢
    String? gender, // 性別
    String? attribute, // 属性
    bool? hasMentalIllness, // 精神疾患有無
    List<String>? mentalIllnesses, // 診断名
    required String createdBy, // レコード登録者
    required DateTime createdAt, // レコード登録日
    required String updatedBy, // レコード更新者
    required DateTime updatedAt, // レコード更新日
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
