import 'package:json_annotation/json_annotation.dart';
part 'videoMeta.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoMeta {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'thumbnail')
  final String thumbnail;
  @JsonKey(name: 'url')
  final String url;
  @JsonKey(name: 'duration')
  final double duration;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'height')
  final int height;
  @JsonKey(name: 'width')
  final int width;

  const VideoMeta(
      {required this.id,
      required this.duration,
      required this.thumbnail,
      required this.url,
      required this.status,
      required this.height,
      required this.width});

  factory VideoMeta.fromJson(Map<String, dynamic> json) {
    return _$VideoMetaFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoMetaToJson(this);
  }
}
