import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:frontend/posts/cubit/sorting/sortEvent.dart';
import 'package:frontend/posts/cubit/sorting/sortState.dart';
import 'package:frontend/posts/cubit/space/spaceState.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

import '../../../config.dart';
import '../../../models/appUser.dart';
import '../../../models/space.dart';
import '../../../stores/store.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class SortBloc extends Bloc<SortEvent, SortState> {
  SortBloc({required this.httpClient}) : super(const SortState()) {
    on<SortChanged>(
      _onSortChange,
      transformer: throttleDroppable(throttleDuration),
    );
    on<DaysSortChanged>(
      _onDaysChange,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

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
