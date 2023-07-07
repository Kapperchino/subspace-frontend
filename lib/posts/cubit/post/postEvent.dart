import 'package:equatable/equatable.dart';

sealed class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class PostFetched extends PostEvent {
  final int postId;
  PostFetched({required this.postId});
}
