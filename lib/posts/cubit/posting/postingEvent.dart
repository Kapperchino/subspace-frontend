import 'package:equatable/equatable.dart';

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
