import 'package:equatable/equatable.dart';
import 'package:frontend/models/postCardData.dart';

enum SpaceStatus { initial, success, failure }

enum SortStatus { latest, popular }

enum SortDays { week, month, halfYear, year }

final class SpaceState extends Equatable {
  const SpaceState(
      {this.status = SpaceStatus.initial,
      this.sortState = SortStatus.latest,
      this.posts = const <PostCardData>[],
      this.sortDays = SortDays.week,
      this.hasReachedMax = false,
      this.spaceId = -1,
      this.parentId = -1,
      this.spaceName = ""});

  final SpaceStatus status;
  final List<PostCardData> posts;
  final bool hasReachedMax;
  final SortStatus sortState;
  final SortDays sortDays;
  final int spaceId;
  final int parentId;
  final String spaceName;

  SpaceState copyWith(
      {SortDays? days,
      SpaceStatus? status,
      List<PostCardData>? posts,
      bool? hasReachedMax,
      int? spaceId,
      SortStatus? sortState,
      int? parentId,
      String? spaceName}) {
    return SpaceState(
        status: status ?? this.status,
        posts: posts ?? this.posts,
        spaceId: spaceId ?? this.spaceId,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        sortState: sortState ?? this.sortState,
        parentId: parentId ?? this.parentId,
        spaceName: spaceName ?? this.spaceName,
        sortDays: days ?? sortDays);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props =>
      [status, posts, hasReachedMax, sortState, spaceId, parentId, spaceName];
}
