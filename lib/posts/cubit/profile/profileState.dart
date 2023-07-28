import 'package:equatable/equatable.dart';

import '../../../models/post.dart';

enum ProfileStatus { initial, success, failure }

enum SortStatus { latest, popular }

enum SortDays { week, month, halfYear, year }

final class ProfileState extends Equatable {
  const ProfileState(
      {this.status = ProfileStatus.initial,
      this.sortState = SortStatus.latest,
      this.posts = const <Post>[],
      this.sortDays = SortDays.week,
      this.hasReachedMax = false,
      this.userId = -1});

  final ProfileStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final SortStatus sortState;
  final SortDays sortDays;
  final int userId;

  ProfileState copyWith(
      {SortDays? days,
      ProfileStatus? status,
      List<Post>? posts,
      bool? hasReachedMax,
      int? userId,
      SortStatus? sortState
      }) {
    return ProfileState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        userId: userId ?? this.userId,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        sortState: sortState ?? this.sortState,
        sortDays: days ?? sortDays);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props =>
      [status, posts, hasReachedMax, sortState, userId];
}
