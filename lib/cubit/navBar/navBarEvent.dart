import 'package:equatable/equatable.dart';
import 'package:frontend/cubit/navBar/navBarState.dart';
import 'package:frontend/cubit/space/spaceState.dart';

sealed class NavBarEvent extends Equatable {
  @override
  List<Object> get props => [];
}

final class NavBarChanged extends NavBarEvent {
  final NavBarPage page;

  NavBarChanged({required this.page});
}
