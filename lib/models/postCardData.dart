import 'package:frontend/models/post.dart';

class PostCardData {
  final Post post;
  final String spaceName;
  final int parentSpaceId;

  PostCardData(
      {required this.post,
      required this.spaceName,
      required this.parentSpaceId});
}
