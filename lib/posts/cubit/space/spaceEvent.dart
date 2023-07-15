import 'package:equatable/equatable.dart';
import 'package:frontend/posts/cubit/space/spaceState.dart';

sealed class SpaceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SpaceFetched extends SpaceEvent {
  final int parentId;
  final String spaceName;

  SpaceFetched({required this.parentId, required this.spaceName});
}

final class SpaceSortChanged extends SpaceEvent {
  final SortState sortState;

  SpaceSortChanged({required this.sortState});
}

final class DaysSortChanged extends SpaceEvent {
  final SortDays sortDays;

  DaysSortChanged({required this.sortDays});
}
