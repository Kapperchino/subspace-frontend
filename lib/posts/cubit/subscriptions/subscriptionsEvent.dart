import 'package:equatable/equatable.dart';
import 'package:frontend/posts/cubit/space/spaceState.dart';

sealed class SubscriptionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SubscriptionsFetched extends SubscriptionsEvent {
  SubscriptionsFetched();
}

final class SubscriptionsSortChanged extends SubscriptionsEvent {
  final SortStatus sortState;

  SubscriptionsSortChanged({required this.sortState});
}

final class DaysSortChanged extends SubscriptionsEvent {
  final SortDays sortDays;

  DaysSortChanged({required this.sortDays});
}
