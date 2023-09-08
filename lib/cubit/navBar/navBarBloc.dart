import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:frontend/cubit/navBar/navBarEvent.dart';
import 'package:frontend/cubit/navBar/navBarState.dart';
import 'package:frontend/cubit/sorting/sortEvent.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc({required this.httpClient}) : super(const NavBarState()) {
    on<NavBarChanged>(
      _onNavBarChange,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onNavBarChange(
    NavBarChanged event,
    Emitter<NavBarState> emit,
  ) async {
    return emit(
      state.copyWith(
        page: event.page,
      ),
    );
  }
}
