import 'package:chewie/chewie.dart';
import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:video_player/video_player.dart';

part 'postCardData.g.dart';

@JsonSerializable(includeIfNull: false)
class PostCardData {
  final Post post;
  @JsonKey(includeFromJson: false, includeToJson: false)
  VideoPlayerController? controller;
  @JsonKey(includeFromJson: false, includeToJson: false)
  ChewieController? chewieController;

  PostCardData(
      {required this.post,
      this.controller,
      this.chewieController});

  factory PostCardData.fromJson(Map<String, dynamic> json) {
    return _$PostCardDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PostCardDataToJson(this);
  }
}
