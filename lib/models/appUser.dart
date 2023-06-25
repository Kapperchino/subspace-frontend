import 'package:json_annotation/json_annotation.dart';
part 'appUser.g.dart';

@JsonSerializable()
class AppUser {
  final int id;
  final String displayName;
  final String bio;
  final String email;

  const AppUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.bio = "",
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return _$AppUserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AppUserToJson(this);
  }
}
