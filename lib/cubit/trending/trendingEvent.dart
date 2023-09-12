import 'package:equatable/equatable.dart';

sealed class TrendingEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class HashTagsFetched extends TrendingEvent {
  HashTagsFetched();
}