import 'package:equatable/equatable.dart';

sealed class SpaceHomeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SpacesFetched extends SpaceHomeEvent {
  SpacesFetched();
}
