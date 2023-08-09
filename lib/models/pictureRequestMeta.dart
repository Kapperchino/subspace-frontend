import 'package:json_annotation/json_annotation.dart';
part 'pictureRequestMeta.g.dart';

@JsonSerializable(includeIfNull: false)
class PictureRequestMeta {
  @JsonKey(name: 'width')
  final int width;
  @JsonKey(name: 'height')
  final int height;
  @JsonKey(name: 'url')
  final String? url;

  const PictureRequestMeta(
      {required this.width, required this.height, this.url});

  factory PictureRequestMeta.fromJson(Map<String, dynamic> json) {
    return _$PictureRequestMetaFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PictureRequestMetaToJson(this);
  }
}
