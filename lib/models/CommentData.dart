import 'package:frontend/models/comment.dart';

class CommentData {
  final Comment comment;
  final List<CommentData> children;

  CommentData({required this.comment, required this.children});
}
