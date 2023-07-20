import 'package:equatable/equatable.dart';

sealed class SpaceCreationEvent extends Equatable {
  const SpaceCreationEvent();

  @override
  List<Object> get props => [];
}

final class SpaceCreated extends SpaceCreationEvent {
  final String name;
  final String discription;
  final String picture;
  const SpaceCreated(
      {required this.name, required this.discription, required this.picture});
}
