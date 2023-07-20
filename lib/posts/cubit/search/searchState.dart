import 'package:equatable/equatable.dart';

import '../../../models/space.dart';

enum SearchStatus { initial, success, failure }

final class SearchState extends Equatable {
  const SearchState({this.status = SearchStatus.initial, this.spaces});

  final SearchStatus status;
  final List<Space>? spaces;

  @override
  String toString() {
    return '''SearchState { status: $status}''';
  }

  @override
  List<Object> get props => [status];
}
