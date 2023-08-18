import 'package:frontend/models/pictureMeta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appUserRes.g.dart';

@JsonSerializable(includeIfNull: false)
class AppUserRes {
  @JsonKey(name: 'user_id')
  final int id;
  @JsonKey(name: 'display_name')
  final String displayName;
  final String bio;
  final String email;
  final String token;
  @JsonKey(name: 'picture_meta')
  final PictureMeta? picture;
  @JsonKey(name: 'user_address')
  final String address;

  const AppUserRes({
    required this.id,
    required this.displayName,
    required this.email,
    required this.token,
    required this.address,
    this.picture,
    this.bio = "",
  });

  factory AppUserRes.fromJson(Map<String, dynamic> json) {
    return _$AppUserResFromJson(json);
  }
}
