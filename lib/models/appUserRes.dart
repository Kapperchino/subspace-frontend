import 'dart:ffi';
import 'package:json_annotation/json_annotation.dart';

part 'appUserRes.g.dart';

@JsonSerializable()
class AppUserRes {
  @JsonKey(name: 'user_id')
  final int id;
  @JsonKey(name: 'display_name')
  final String displayName;
  final String bio;
  final String email;
  final String token;

  const AppUserRes({
    required this.id,
    required this.displayName,
    required this.email,
    required this.token,
    this.bio = "",
  });

  factory AppUserRes.fromJson(Map<String, dynamic> json) {
    return _$AppUserResFromJson(json);
  }
}
