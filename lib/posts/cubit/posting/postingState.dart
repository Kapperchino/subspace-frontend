import 'package:equatable/equatable.dart';

enum PostingStatus { closed, started, success, failure }

enum PostingMode { text, link }

final class PostingState extends Equatable {
  const PostingState(
      {this.status = PostingStatus.closed, this.mode = PostingMode.text});
  final PostingStatus status;
  final PostingMode mode;

  PostingState copyWith({PostingStatus? status, PostingMode? mode}) {
    return PostingState(status: status ?? this.status, mode: mode ?? this.mode);
  }

  @override
  List<Object> get props => [status, mode];
}
