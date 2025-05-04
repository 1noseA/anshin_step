import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String userName,
    int? age,
    String? gender,
    String? attribute,
    bool? hasMentalIllness,
    List<String>? mentalIllnesses,
    required String createdBy,
    required DateTime createdAt,
    required String updatedBy,
    required DateTime updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
