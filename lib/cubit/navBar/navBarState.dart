import 'package:equatable/equatable.dart';

enum NavBarPage {
  home(0),
  spaces(1),
  search(2),
  notification(3);

  const NavBarPage(this.page);
  final int page;

  static NavBarPage getByValue(num i) {
    return NavBarPage.values.firstWhere((x) => x.page == i);
  }
}

final class NavBarState extends Equatable {
  const NavBarState(
      {this.page = NavBarPage.home, this.lastTime, this.doubleTap = false});

  final NavBarPage page;
  final DateTime? lastTime;
  final bool doubleTap;

  NavBarState copyWith(
      {NavBarPage? page, DateTime? lastTime, bool? doubleTap}) {
    return NavBarState(
        page: page ?? this.page,
        lastTime: lastTime ?? this.lastTime,
        doubleTap: doubleTap ?? this.doubleTap);
  }

  @override
  List<Object> get props => [page, lastTime ?? DateTime.now(), doubleTap];
}
