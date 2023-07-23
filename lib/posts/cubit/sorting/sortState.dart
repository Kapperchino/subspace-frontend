import 'package:equatable/equatable.dart';
import 'package:frontend/models/postCardData.dart';

import '../space/spaceState.dart';

final class SortState extends Equatable {
  const SortState({
    this.status = SortStatus.latest,
    this.sortDays = SortDays.week,
  });

  final SortStatus status;
  final SortDays sortDays;

  SortState copyWith({SortDays? days, SortStatus? status}) {
    return SortState(status: status ?? this.status, sortDays: days ?? sortDays);
  }

  @override
  String toString() {
    return '''SortState { status: $status,  }''';
  }

  @override
  List<Object> get props => [status, sortDays];
}
