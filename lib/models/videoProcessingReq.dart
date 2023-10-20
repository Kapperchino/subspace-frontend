import 'package:json_annotation/json_annotation.dart';
part 'videoProcessingReq.g.dart';

@JsonSerializable(explicitToJson: true)
class VideoProcessingReq {
  @JsonKey(name: 'id')
  final int id;

  const VideoProcessingReq({required this.id});

  factory VideoProcessingReq.fromJson(Map<String, dynamic> json) {
    return _$VideoProcessingReqFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$VideoProcessingReqToJson(this);
  }
}
