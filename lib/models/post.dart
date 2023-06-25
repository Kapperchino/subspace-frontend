
import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';

enum ContentType { text, picture, video }

@JsonSerializable()
class Post {
  final int id;
  @JsonKey(name: 'space_id')
  final int spaceId;
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
  final ContentType type;

  const Post(
      {required this.id,
      required this.spaceId,
      required this.posterId,
      required this.topic,
      required this.posterName,
      this.body = "",
      this.content = "",
      this.type = ContentType.text,
      required this.upVotes,
      required this.downVotes,
      required this.created});

  factory Post.fromJson(Map<String, dynamic> json) {
    return _$PostFromJson(json);
  }
}
