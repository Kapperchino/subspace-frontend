import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/navBar/navBarEvent.dart';
import 'package:frontend/cubit/navBar/navBarState.dart';


class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(const NavBarState()) {
    on<NavBarChanged>(
      _onNavBarChange,
    );
  }

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
