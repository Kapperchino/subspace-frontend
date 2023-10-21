import 'dart:math';

import 'package:chewie/chewie.dart';
import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

import '../../models/post.dart';

enum PostStatus { initial, success, failure }

final class PostState extends Equatable {
  PostState(
      {this.status = PostStatus.initial,
      Post? post,
      this.controller,
      this.chewieController});

  final PostStatus status;
  VideoPlayerController? controller;
  ChewieController? chewieController;
  Post? post;

  @override
  String toString() {
    return '''PostState { status: $status, post: $post }''';
  }

  @override
  List<Object> get props => [status, post?.id ?? Random()];
}
