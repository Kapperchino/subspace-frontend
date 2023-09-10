import 'package:equatable/equatable.dart';
import '../../models/space.dart';

enum SpaceHomeStatus { initial, success, failure }

final class SpaceHomeState extends Equatable {
  const SpaceHomeState({
    this.status = SpaceHomeStatus.initial,
    this.popularSpaces,
    this.latestSpaces,
  });

  final SpaceHomeStatus status;
  final List<Space>? popularSpaces;
  final List<Space>? latestSpaces;

  SpaceHomeState copyWith(
      {SpaceHomeStatus? status,
      List<Space>? popularSpaces,
      List<Space>? latestSpaces}) {
    return SpaceHomeState(
      status: status ?? this.status,
      popularSpaces: popularSpaces ?? this.popularSpaces,
      latestSpaces: latestSpaces ?? this.latestSpaces,
    );
  }

  @override
  String toString() {
    return '''SearchState { status: $status}''';
  }

  @override
  List<Object> get props => [status, popularSpaces ?? 1, latestSpaces ?? 1];
}
