import 'package:json_annotation/json_annotation.dart';
part 'videoProcessingRes.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoProcessingRes {
  @JsonKey(name: 'duration')
  final double duration;
  @JsonKey(name: 'thumbnail')
  final String thumbnail;
  final String url;

  const VideoProcessingRes(
      {required this.url, required this.thumbnail, required this.duration});

  factory VideoProcessingRes.fromJson(Map<String, dynamic> json) {
    return _$VideoProcessingResFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoProcessingResToJson(this);
  }
}
