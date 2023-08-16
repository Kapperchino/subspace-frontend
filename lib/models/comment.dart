import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/vote.dart';
import 'package:json_annotation/json_annotation.dart';
part 'comment.g.dart';

@JsonSerializable(includeIfNull: false)
class Comment {
  final int id;
  @JsonKey(name: 'poster_id')
  final int posterId;
  @JsonKey(name: 'poster_name')
  final String posterName;
  @JsonKey(name: 'post_id')
  final int postId;
  final String body;
  final String content;
  @JsonKey(name: 'poster_picture')
  final PictureMeta? posterPicture;
  @JsonKey(name: 'parent_id')
  final int parentId;
  @JsonKey(name: 'up_votes')
  final int upVotes;
  @JsonKey(name: 'down_votes')
  final int downVotes;
  final DateTime created;
  @JsonKey(name: 'content_type')
  final ContentType type;
  @JsonKey(name: 'vote')
  final Vote? vote;

  const Comment(
      {required this.id,
      required this.posterId,
      required this.posterName,
      required this.body,
      this.content = "",
      this.type = ContentType.text,
      this.posterPicture,
      required this.upVotes,
      required this.parentId,
      required this.downVotes,
      required this.created,
      required this.postId,
      required this.vote});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return _$CommentFromJson(json);
  }
}
