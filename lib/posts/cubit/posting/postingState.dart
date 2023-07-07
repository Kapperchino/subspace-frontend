import 'package:equatable/equatable.dart';

enum PostingStatus { closed, started, success, failure }

final class PostingState extends Equatable {
  const PostingState({this.status = PostingStatus.closed});
  final PostingStatus status;

  PostingState copyWith({PostingStatus? status}) {
    return PostingState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
