import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/cubit/sorting/sortEvent.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:stream_transform/stream_transform.dart';

class SortBloc extends Bloc<SortEvent, SortState> {
  SortBloc() : super(const SortState()) {
    on<SortChanged>(
      _onSortChange,
    );
    on<DaysSortChanged>(
      _onDaysChange,
    );
  }

  Future<void> _onDaysChange(
    DaysSortChanged event,
    Emitter<SortState> emit,
  ) async {
    return emit(
      state.copyWith(
        days: event.sortDays,
      ),
    );
  }

  Future<void> _onSortChange(
    SortChanged event,
    Emitter<SortState> emit,
  ) async {
    return emit(
      state.copyWith(
        status: event.sortState,
      ),
    );
  }
}
