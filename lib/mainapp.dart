import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/navBar/navBarBloc.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/routes/createRoutes.dart';
import 'package:frontend/routes/imageRoutes.dart';
import 'package:frontend/routes/loginRoutes.dart';
import 'package:frontend/routes/notificationRoutes.dart';
import 'package:frontend/routes/searchRoute.dart';
import 'package:frontend/routes/spaceRoutes.dart';
import 'package:frontend/routes/userRoutes.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final _router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: "/home",
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          redirect: (context, state) async {
            DateTime? expire = await UserUtil.getExpire();
            if (expire != null) {
              if (expire.isBefore(DateTime.now())) {
                return "/login";
              } else {
                return "/home";
              }
            }
            return "/login";
          },
        ),
        SpaceRoutes().getHome(),
        SpaceRoutes().getSpaceRoute(),
        SpaceRoutes().getSpaceHome(),
        AuthRoute().getSignupRoute(),
        AuthRoute().getLoginRoute(),
        CreateRoutes().getPostCreationRoute(),
        CreateRoutes().getSpaceCreationRoute(),
        SearchRoutes().getSearchRoute(),
        SearchRoutes().getSearchRouteHome(),
        ImageRoutes().getImageRoute(),
        UserRoutes().getUserRoute(),
        NotificationRoute().getNotificationRoute()
      ]);

  @override
  Widget build(BuildContext context) {
    var theme = const ColorScheme.dark();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NavBarBloc()),
          BlocProvider(create: (_) => SortBloc()),
        ],
        child: MaterialApp.router(
          theme: ThemeData(
              // Define the default brightness and colors.
              colorScheme: theme,
              useMaterial3: true),
          routerConfig: _router,
        ));
  }
}
