import 'package:json_annotation/json_annotation.dart';
part 'videoMetaResult.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoMetaResult {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'presigned')
  final String presigned;
  final String url;

  const VideoMetaResult(
      {required this.id, required this.presigned, required this.url});

  factory VideoMetaResult.fromJson(Map<String, dynamic> json) {
    return _$VideoMetaResultFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoMetaResultToJson(this);
  }
}
