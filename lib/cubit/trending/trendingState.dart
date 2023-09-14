import 'package:equatable/equatable.dart';
import 'package:frontend/models/tagMeta.dart';

enum TrendingStatus { initial, success, failure }

final class TrendingState extends Equatable {
  const TrendingState({
    this.status = TrendingStatus.initial,
    this.tags,
  });

  final TrendingStatus status;
  final List<TagMeta>? tags;

  TrendingState copyWith({TrendingStatus? status, List<TagMeta>? tags}) {
    return TrendingState(
        status: status ?? this.status, tags: tags ?? this.tags);
  }

  @override
  String toString() {
    return '''SearchState { status: $status}''';
  }

  @override
  List<Object> get props => [status, tags ?? 1];
}
