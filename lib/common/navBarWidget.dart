import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/navBar/navBarBloc.dart';
import 'package:frontend/cubit/navBar/navBarEvent.dart';
import 'package:frontend/cubit/navBar/navBarState.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/posts/sortByModal.dart';
import 'package:frontend/posts/sortDaysModal.dart';
import 'package:go_router/go_router.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavBarBloc, NavBarState>(
      builder: (context, state) {
        return Hero(
            tag: "nav",
            child: NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                height: 50,
                selectedIndex: state.page.page,
                onDestinationSelected: (value) {
                  context.read<NavBarBloc>().add(NavBarChanged(
                      page: NavBarPage.getByValue(value),
                      time: DateTime.timestamp()));
                  switch (value) {
                    case 0:
                      {
                        if (DateTime.timestamp()
                                .difference(
                                    state.lastTime ?? DateTime.timestamp())
                                .inMilliseconds <
                            350) {
                          context.read<NavBarBloc>().add(DoubleTapped());
                        }
                        context.replace("/home");
                      }
                    case 1:
                      {
                        context.replace("/s/home");
                      }
                    case 2:
                      {
                        context.replace("/search/home");
                      }
                    case 3:
                      {
                        context.replace("/notifications");
                      }
                  }
                },
                destinations: [
                  const NavigationDestination(
                    selectedIcon: Icon(Icons.home),
                    icon: Icon(Icons.home_outlined),
                    label: 'Home',
                  ),
                  const NavigationDestination(
                    selectedIcon: Icon(Icons.satellite_alt),
                    icon: Icon(Icons.satellite_alt_outlined),
                    label: 'Spaces',
                  ),
                  const NavigationDestination(
                    selectedIcon: Icon(Icons.search),
                    icon: Icon(Icons.search_outlined),
                    label: 'Search',
                  ),
                  const NavigationDestination(
                    selectedIcon: Icon(Icons.notifications),
                    icon: Icon(Icons.notifications_outlined),
                    label: 'Notifications',
                  ),
                  MenuAnchor(
                      builder: (BuildContext context, MenuController controller,
                          Widget? child) {
                        return IconButton(
                          onPressed: () {
                            if (controller.isOpen) {
                              controller.close();
                            } else {
                              controller.open();
                            }
                          },
                          icon: const Icon(Icons.sort_outlined),
                          tooltip: 'Show menu',
                        );
                      },
                      menuChildren: [
                        MenuItemButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context1) {
                                  return BlocProvider.value(
                                      value: BlocProvider.of<SortBloc>(context),
                                      child: const SortByModal());
                                });
                          },
                          child: const Text('Sort by'),
                        ),
                        MenuItemButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context1) {
                                  return BlocProvider.value(
                                      value: BlocProvider.of<SortBloc>(context),
                                      child: const SortDaysModal());
                                });
                          },
                          child: const Text('Days'),
                        ),
                      ]),
                ]));
      },
    );
  }
}
