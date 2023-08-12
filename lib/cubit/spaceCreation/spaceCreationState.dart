import 'package:equatable/equatable.dart';

enum SpaceCreationStatus { started, success, failure }

final class SpaceCreationState extends Equatable {
  const SpaceCreationState(
      {this.status = SpaceCreationStatus.started, this.parentId = 1});
  final SpaceCreationStatus status;
  final int parentId;

  SpaceCreationState copyWith({SpaceCreationStatus? status, int? parentId}) {
    return SpaceCreationState(
        status: status ?? this.status, parentId: parentId ?? this.parentId);
  }

  @override
  List<Object> get props => [status, parentId];
}
