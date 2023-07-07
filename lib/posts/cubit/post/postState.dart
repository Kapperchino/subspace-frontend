import 'package:equatable/equatable.dart';

import '../../../models/post.dart';

enum PostStatus { initial, success, failure }

final class PostState extends Equatable {
  PostState({this.status = PostStatus.initial, Post? post});

  final PostStatus status;
  Post? post;

  @override
  String toString() {
    return '''PostState { status: $status, post: $post }''';
  }

  @override
  List<Object> get props => [status];
}
