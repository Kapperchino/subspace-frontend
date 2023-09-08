import 'package:equatable/equatable.dart';
import 'package:frontend/cubit/space/spaceState.dart';

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

final class SubscriptionDaysSortChanged extends SubscriptionsEvent {
  final SortDays sortDays;

  SubscriptionDaysSortChanged({required this.sortDays});
}
