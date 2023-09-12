import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postCardData.g.dart';

@JsonSerializable(includeIfNull: false)
class PostCardData {
  final Post post;
  final String spaceName;
  final int parentSpaceId;

  PostCardData(
      {required this.post,
      required this.spaceName,
      required this.parentSpaceId});

  factory PostCardData.fromJson(Map<String, dynamic> json) {
    return _$PostCardDataFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PostCardDataToJson(this);
  }
}
