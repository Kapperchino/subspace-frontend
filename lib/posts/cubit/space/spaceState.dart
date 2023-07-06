import 'package:equatable/equatable.dart';
import 'package:frontend/models/postCardData.dart';

enum SpaceStatus { initial, success, failure }

final class SpaceState extends Equatable {
  const SpaceState(
      {this.status = SpaceStatus.initial,
      this.posts = const <PostCardData>[],
      this.hasReachedMax = false,
      this.posting = false});

  final SpaceStatus status;
  final List<PostCardData> posts;
  final bool hasReachedMax;
  final bool posting;

  SpaceState copyWith({
    SpaceStatus? status,
    List<PostCardData>? posts,
    bool? hasReachedMax,
  }) {
    return SpaceState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}
