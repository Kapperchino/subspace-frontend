import 'package:equatable/equatable.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';

sealed class PostingEvent extends Equatable {
  const PostingEvent();

  @override
  List<Object> get props => [];
}

final class ModeChanged extends PostingEvent {
  final PostingMode mode;
  const ModeChanged(this.mode);
}

final class PostPressed extends PostingEvent {
  final String topic;
  final String body;
  final int spaceId;
  final ContentType contentType;
  final String content;
  const PostPressed(
      {this.topic = "",
      required this.body,
      required this.spaceId,
      this.content = "",
      this.contentType = ContentType.text});
}
