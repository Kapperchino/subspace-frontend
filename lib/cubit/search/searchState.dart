import 'package:equatable/equatable.dart';
import 'package:frontend/cubit/space/spaceState.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/models/userMeta.dart';

import '../../models/post.dart';
import '../../models/space.dart';

enum SearchStatus { initial, success, failure }

final class SearchState extends Equatable {
  const SearchState(
      {this.status = SearchStatus.initial,
      this.spaces,
      this.posts,
      this.sortStatus = SortStatus.popular,
      this.sortDays = SortDays.week,
      this.users,
      this.term = "",
      this.isTag = false});

  final SearchStatus status;
  final SortStatus sortStatus;
  final SortDays sortDays;
  final String term;
  final bool isTag;
  final List<Space>? spaces;
  final List<PostCardData>? posts;
  final List<UserMeta>? users;

  SearchState copyWith(
      {SearchStatus? status,
      List<PostCardData>? posts,
      List<Space>? spaces,
      SortStatus? sortStatus,
      List<UserMeta>? users,
      SortDays? sortDays,
      String? term,
      bool? isTag}) {
    return SearchState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      sortStatus: sortStatus ?? this.sortStatus,
      sortDays: sortDays ?? this.sortDays,
      users: users ?? this.users,
      spaces: spaces ?? this.spaces,
      term: term ?? this.term,
      isTag: isTag ?? this.isTag,
    );
  }

  @override
  String toString() {
    return '''SearchState { status: $status}''';
  }

  @override
  List<Object> get props => [status, sortStatus, sortDays, term, isTag];
}
