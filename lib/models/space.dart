import 'package:frontend/models/pictureMeta.dart';
import 'package:json_annotation/json_annotation.dart';
part 'space.g.dart';

@JsonSerializable(includeIfNull: false)
class Space {
  final int id;
  @JsonKey(name: 'parent_id')
  final int parentId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'small_picture')
  final PictureMeta? smallPicture;
  @JsonKey(name: 'background_picture')
  final PictureMeta? backgroundPicture;
  @JsonKey(name: 'sub_count')
  final int subCount;

  const Space(
      {required this.id,
      required this.parentId,
      required this.name,
      required this.description,
      this.backgroundPicture,
      this.smallPicture,
      required this.subCount});

  factory Space.fromJson(Map<String, dynamic> json) {
    return _$SpaceFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SpaceToJson(this);
  }
}
