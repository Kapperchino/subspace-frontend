import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/navBar/navBarBloc.dart';
import 'package:frontend/cubit/navBar/navBarEvent.dart';
import 'package:frontend/cubit/navBar/navBarState.dart';
import 'package:frontend/cubit/notification/notificationBloc.dart';
import 'package:frontend/cubit/notification/notificationState.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/posts/sortByModal.dart';
import 'package:frontend/posts/sortDaysModal.dart';
import 'package:go_router/go_router.dart';
import 'package:localstore/localstore.dart';

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
                  context
                      .read<NavBarBloc>()
                      .add(NavBarChanged(page: NavBarPage.getByValue(value)));
                  switch (value) {
                    case 0:
                      {
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
                  NavigationDestination(
                    selectedIcon: getIcons(),
                    icon: getIconOutlines(),
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

  Widget getIconOutlines() {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        final mentions = state.mentions;
        if (mentions != null && mentions.isNotEmpty) {
          return const Icon(Icons.notifications_active_outlined);
        }
        final replies = state.notifications;
        if (replies != null && replies.isNotEmpty) {
          return const Icon(Icons.notifications_active_outlined);
        }
        return const Icon(Icons.notifications_none_outlined);
      },
    );
  }

  Widget getIcons() {
    return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
      final mentions = state.mentions;
      if (mentions != null && mentions.isNotEmpty) {
        return const Icon(Icons.notifications_active);
      }
      final replies = state.notifications;
      if (replies != null && replies.isNotEmpty) {
        return const Icon(Icons.notifications_active);
      }
      return const Icon(Icons.notifications_none);
    });
  }
}
