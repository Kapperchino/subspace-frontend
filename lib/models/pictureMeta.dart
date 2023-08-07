import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pictureMeta.g.dart';

@JsonSerializable()
class PictureMeta {
  @JsonKey(name: 'width')
  final int width;
  @JsonKey(name: 'height')
  final int height;
  @JsonKey(name: 'url')
  final String url;

  const PictureMeta(
      {required this.width, required this.height, required this.url});

  factory PictureMeta.fromJson(Map<String, dynamic> json) {
    return _$PictureMetaFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PictureMetaToJson(this);
  }
}
