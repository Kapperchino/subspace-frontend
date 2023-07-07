import 'package:equatable/equatable.dart';

enum CommentingStaus { closed, started, success, failure }

final class CommentingState extends Equatable {
  const CommentingState({this.status = CommentingStaus.closed});
  final CommentingStaus status;

  CommentingState copyWith({CommentingStaus? status}) {
    return CommentingState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
