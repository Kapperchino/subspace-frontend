import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'pictureRequestMeta.g.dart';

@JsonSerializable()
class PictureRequestMeta {
  @JsonKey(name: 'width')
  final int width;
  @JsonKey(name: 'height')
  final int height;

  const PictureRequestMeta({required this.width, required this.height});

  factory PictureRequestMeta.fromJson(Map<String, dynamic> json) {
    return _$PictureRequestMetaFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PictureRequestMetaToJson(this);
  }
}
