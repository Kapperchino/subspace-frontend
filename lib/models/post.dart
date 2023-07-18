import 'package:frontend/models/vote.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';

enum ContentType {
  @JsonValue("text")
  text,
  @JsonValue("picture")
  picture,
  @JsonValue("video")
  video,
  @JsonValue("link")
  link,
  @JsonValue("unknown")
  unknown
}

@JsonSerializable(includeIfNull: false)
class Post {
  final int id;
  @JsonKey(name: 'space_id')
  final int spaceId;
  @JsonKey(name: 'space_picture')
  final String spacePicture;
  @JsonKey(name: 'poster_id')
  final int posterId;
  @JsonKey(name: 'poster_name')
  final String posterName;
  final String topic;
  final String body;
  final String content;
  @JsonKey(name: 'up_votes')
  final int upVotes;
  @JsonKey(name: 'down_votes')
  final int downVotes;
  final DateTime created;
  @JsonKey(name: 'content_type')
  final ContentType type;
  @JsonKey(name: 'vote')
  final Vote? vote;

  const Post(
      {required this.id,
      required this.spaceId,
      required this.posterId,
      required this.topic,
      required this.posterName,
      this.body = "",
      this.content = "",
      this.spacePicture = "",
      this.type = ContentType.text,
      required this.upVotes,
      required this.downVotes,
      required this.created,
      required this.vote});

  factory Post.fromJson(Map<String, dynamic> json) {
    return _$PostFromJson(json);
  }
}
