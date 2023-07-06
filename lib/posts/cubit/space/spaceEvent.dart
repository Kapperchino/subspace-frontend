import 'package:equatable/equatable.dart';

sealed class SpaceEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class SpaceFetched extends SpaceEvent {
  final int parentId;
  final String spaceName;

  SpaceFetched({required this.parentId, required this.spaceName});
}
