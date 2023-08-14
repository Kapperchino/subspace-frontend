import 'package:json_annotation/json_annotation.dart';
part 'pictureMetaResult.g.dart';

@JsonSerializable()
class PictureMetaResult {
  @JsonKey(name: 'width')
  final int width;
  @JsonKey(name: 'height')
  final int height;
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'presigned')
  final String presigned;
  final String url;

  const PictureMetaResult(
      {required this.width,
      required this.height,
      required this.id,
      required this.presigned,
      required this.url});

  factory PictureMetaResult.fromJson(Map<String, dynamic> json) {
    return _$PictureMetaResultFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PictureMetaResultToJson(this);
  }
}
