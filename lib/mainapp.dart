import 'package:flutter/material.dart';
import 'package:frontend/routes/createRoutes.dart';
import 'package:frontend/routes/loginRoutes.dart';
import 'package:frontend/routes/searchRoute.dart';
import 'package:frontend/routes/spaceRoutes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final _router =
      GoRouter(initialLocation: "/s/1/SubSpace", routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (context, state) {
        String? expire = GetStorage().read("expire");
        if (expire != null) {
          final time = DateTime.parse(expire);
          if (time.isBefore(DateTime.now())) {
            return "/login";
          } else {
            return "/s/1/SubSpace";
          }
        }
        return "/login";
      },
    ),
    SpaceRoutes().getSpaceRoute(),
    AuthRoute().getSignupRoute(),
    AuthRoute().getLoginRoute(),
    CreateRoutes().getPostCreationRoute(),
    CreateRoutes().getSpaceCreationRoute(),
    SearchRoutes().getSearchRoute()
  ]);

  @override
  Widget build(BuildContext context) {
    var theme = const ColorScheme.dark(primary: Colors.blue);
    return MaterialApp.router(
        theme: ThemeData(
            // Define the default brightness and colors.
            colorScheme: theme,
            useMaterial3: true),
        routerConfig: _router);
  }
}
