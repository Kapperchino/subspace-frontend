import 'package:equatable/equatable.dart';
import 'package:frontend/models/post.dart';

sealed class PostingEvent extends Equatable {
  const PostingEvent();

  @override
  List<Object> get props => [];
}

final class PostPressed extends PostingEvent {
  final String topic;
  final String body;
  final int spaceId;
  const PostPressed(
      {this.topic = "", required this.body, required this.spaceId});
}

final class LinkPostPressed extends PostingEvent {
  final String topic;
  final String body;
  final int spaceId;
  final ContentType contentType;
  final String content;
  const LinkPostPressed(
      {this.topic = "",
      required this.body,
      required this.spaceId,
      required this.content,
      required this.contentType});
}
