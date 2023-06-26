import 'package:frontend/models/post.dart';
import 'package:frontend/models/space.dart';

class SpaceView {
  final Space space;
  final List<Post> posts;

  const SpaceView({required this.space, required this.posts});
}
