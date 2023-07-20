import 'package:flutter/material.dart';
import 'package:frontend/routes/createRoutes.dart';
import 'package:frontend/routes/loginRoutes.dart';
import 'package:frontend/routes/searchRoute.dart';
import 'package:frontend/routes/spaceRoutes.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final _router =
      GoRouter(initialLocation: "/s/1/SubSpace", routes: <RouteBase>[
    SpaceRoutes().getSpaceRoute(),
    AuthRoute().getSignupRoute(),
    AuthRoute().getLoginRoute(),
    CreateRoutes().getPostCreationRoute(),
    CreateRoutes().getSpaceCreationRoute(),
    SearchRoutes().getSearchRoute()
  ]);

  @override
  Widget build(BuildContext context) {
    var theme = const ColorScheme.light(
        secondary: Colors.black,
        background: Colors.grey,
        primaryContainer: Colors.white10,
        primary: Colors.blueGrey);
    return MaterialApp.router(
        theme: ThemeData(
            // Define the default brightness and colors.
            colorScheme: theme,
            useMaterial3: true),
        routerConfig: _router);
  }
}
