import 'package:frontend/models/pictureMeta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'appUser.g.dart';

@JsonSerializable(includeIfNull: false)
class AppUser {
  @JsonKey(name: 'user_id')
  final int id;
  @JsonKey(name: 'display_name')
  final String displayName;
  final String bio;
  final String email;
  @JsonKey(name: 'user_address')
  final String address;
  @JsonKey(name: 'picture_meta')
  final PictureMeta? picture;

  const AppUser(
      {required this.id,
      required this.displayName,
      required this.email,
      required this.address,
      this.bio = "",
      this.picture});

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return _$AppUserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AppUserToJson(this);
  }
}
