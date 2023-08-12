import 'package:equatable/equatable.dart';

sealed class SearchEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SearchFetched extends SearchEvent {
  final String term;
  final bool isTag;
  SearchFetched({required this.term, required this.isTag});
}
