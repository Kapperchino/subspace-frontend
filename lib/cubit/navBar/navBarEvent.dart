import 'package:equatable/equatable.dart';
import 'package:frontend/cubit/navBar/navBarState.dart';

sealed class NavBarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class NavBarChanged extends NavBarEvent {
  final NavBarPage page;
  final DateTime time;

  NavBarChanged({required this.page, required this.time});
}

final class DoubleTapped extends NavBarEvent {
  DoubleTapped();
}
