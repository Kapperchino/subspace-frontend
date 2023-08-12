import 'package:equatable/equatable.dart';
import 'package:frontend/models/appUser.dart';
import 'package:frontend/models/post.dart';

import '../../models/userMeta.dart';
import '../space/spaceState.dart';

enum UserPageStatus { initial, success, failure }

final class UserPageState extends Equatable {
  const UserPageState(
      {this.status = UserPageStatus.initial,
      this.sortState = SortStatus.latest,
      this.posts = const <Post>[],
      this.sortDays = SortDays.week,
      this.hasReachedMax = false,
      this.user});

  final UserPageStatus status;
  final List<Post> posts;
  final bool hasReachedMax;
  final SortStatus sortState;
  final SortDays sortDays;
  final UserMeta? user;

  UserPageState copyWith(
      {SortDays? days,
      UserPageStatus? status,
      List<Post>? posts,
      bool? hasReachedMax,
      SortStatus? sortState,
      UserMeta? user}) {
    return UserPageState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        sortState: sortState ?? this.sortState,
        sortDays: days ?? sortDays,
        user: user ?? this.user);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props =>
      [status, posts, hasReachedMax, sortState, user ?? -1];
}
