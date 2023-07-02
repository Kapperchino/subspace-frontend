import 'package:frontend/models/post.dart';
import 'package:json_annotation/json_annotation.dart';
part 'postRequest.g.dart';

@JsonSerializable()
class PostRequest {
  @JsonKey(name: 'space_id')
  final int spaceId;
  @JsonKey(name: 'poster_id')
  final int posterId;
  final String topic;
  final String body;
  final String content;
  @JsonKey(name: 'content_type')
  final ContentType type;

  const PostRequest({
    required this.spaceId,
    required this.posterId,
    required this.topic,
    this.body = "",
    this.content = "",
    this.type = ContentType.text,
  });

  factory PostRequest.fromJson(Map<String, dynamic> json) {
    return _$PostRequestFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$PostRequestToJson(this);
  }
}
