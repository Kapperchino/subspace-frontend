import 'package:equatable/equatable.dart';

sealed class PostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class PostFetched extends PostEvent {
  final int postId;
  final double deviceWidth;
  PostFetched({required this.postId, required this.deviceWidth});
}
