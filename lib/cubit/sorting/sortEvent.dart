import 'package:equatable/equatable.dart';
import 'package:frontend/cubit/space/spaceState.dart';

sealed class SortEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SortChanged extends SortEvent {
  final SortStatus sortState;

  SortChanged({required this.sortState});
}

final class DaysSortChanged extends SortEvent {
  final SortDays sortDays;

  DaysSortChanged({required this.sortDays});
}
