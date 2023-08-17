import 'package:equatable/equatable.dart';
import 'package:frontend/cubit/space/spaceState.dart';

sealed class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SearchFetched extends SearchEvent {
  final String term;
  final bool isTag;
  SearchFetched({required this.term, required this.isTag});
}

final class SearchSortChanged extends SearchEvent {
  final SortStatus status;
  SearchSortChanged({required this.status});
}

final class SearchSortDaysChanged extends SearchEvent {
  final SortDays days;
  SearchSortDaysChanged({required this.days});
}
