import 'package:frontend/models/pictureMeta.dart';
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
  final PictureMeta? spacePicture;
  @JsonKey(name: 'poster_id')
  final int posterId;
  @JsonKey(name: 'poster_name')
  final String posterName;
  @JsonKey(name: 'poster_picture')
  final PictureMeta? posterPicture;
  final String topic;
  final String body;
  @JsonKey(name: 'post_pictures')
  final List<PictureMeta>? postPictures;
  @JsonKey(name: 'up_votes')
  final int upVotes;
  @JsonKey(name: 'down_votes')
  final int downVotes;
  @JsonKey(name: "link")
  final String? link;
  final DateTime created;
  @JsonKey(name: 'content_type')
  final ContentType type;
  @JsonKey(name: 'vote')
  final Vote? vote;
  @JsonKey(name: 'space_parent_id')
  final int spaceParentId;
  @JsonKey(name: 'space_name')
  final String spaceName;

  const Post(
      {required this.id,
      required this.spaceId,
      required this.posterId,
      required this.topic,
      required this.posterName,
      this.body = "",
      this.postPictures,
      this.spacePicture,
      this.type = ContentType.text,
      this.link,
      required this.upVotes,
      required this.downVotes,
      required this.created,
      required this.spaceParentId,
      required this.vote,
      required this.spaceName,
      required this.posterPicture});

  factory Post.fromJson(Map<String, dynamic> json) {
    return _$PostFromJson(json);
  }
}
