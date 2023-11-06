import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/navBar/navBarEvent.dart';
import 'package:frontend/cubit/navBar/navBarState.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarState()) {
    on<NavBarChanged>(
      _onNavBarChange,
    );
    on<DoubleTapped>(_onDoubleTap);
  }

  Future<void> _onNavBarChange(
    NavBarChanged event,
    Emitter<NavBarState> emit,
  ) async {
    return emit(
      state.copyWith(
        lastTime: event.time,
        page: event.page,
      ),
    );
  }

  Future<void> _onDoubleTap(
    DoubleTapped event,
    Emitter<NavBarState> emit,
  ) async {
    return emit(
      state.copyWith(
          doubleTap: !state.doubleTap,
          lastTime: DateTime.now().subtract(const Duration(hours: 1))),
    );
  }
}
