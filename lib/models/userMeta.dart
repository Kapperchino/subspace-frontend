import 'package:frontend/models/pictureMeta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'userMeta.g.dart';

@JsonSerializable(includeIfNull: false)
class UserMeta {
  @JsonKey(name: "user_id")
  final int id;
  @JsonKey(name: "display_name")
  final String displayName;
  final String bio;
  @JsonKey(name: "picture_meta")
  final PictureMeta? picture;

  const UserMeta(
      {required this.id,
      required this.displayName,
      this.bio = "",
      this.picture});

  factory UserMeta.fromJson(Map<String, dynamic> json) {
    return _$UserMetaFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserMetaToJson(this);
  }
}
