import 'package:equatable/equatable.dart';
import 'package:frontend/models/postCardData.dart';

import '../space/spaceState.dart';

enum SubscriptionsStatus { initial, success, failure }

final class SubscriptionsState extends Equatable {
  const SubscriptionsState(
      {this.status = SubscriptionsStatus.initial,
      this.sortState = SortStatus.latest,
      this.posts = const <PostCardData>[],
      this.sortDays = SortDays.week,
      this.hasReachedMax = false});

  final SubscriptionsStatus status;
  final List<PostCardData> posts;
  final bool hasReachedMax;
  final SortStatus sortState;
  final SortDays sortDays;

  SubscriptionsState copyWith(
      {SortDays? days,
      SubscriptionsStatus? status,
      List<PostCardData>? posts,
      bool? hasReachedMax,
      SortStatus? sortState}) {
    return SubscriptionsState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        sortState: sortState ?? this.sortState,
        sortDays: days ?? sortDays);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax, sortState];
}
