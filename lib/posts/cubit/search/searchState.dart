import 'package:equatable/equatable.dart';

import '../../../models/post.dart';
import '../../../models/postCardData.dart';
import '../../../models/space.dart';

enum SearchStatus { initial, success, failure }

final class SearchState extends Equatable {
  const SearchState(
      {this.status = SearchStatus.initial, this.spaces, this.posts});

  final SearchStatus status;
  final List<Space>? spaces;
  final List<Post>? posts;

  @override
  String toString() {
    return '''SearchState { status: $status}''';
  }

  @override
  List<Object> get props => [status];
}
