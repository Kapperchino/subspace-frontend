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
  const NavBarState({
    this.page = NavBarPage.home,
  });

  final NavBarPage page;

  NavBarState copyWith({NavBarPage? page}) {
    return NavBarState(page: page ?? this.page);
  }

  @override
  List<Object> get props => [page];
}
