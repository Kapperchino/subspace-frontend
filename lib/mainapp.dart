import 'package:flutter/material.dart';
import 'package:frontend/intro/home.dart';
import 'package:frontend/intro/login.dart';
import 'package:frontend/routes/loginRoutes.dart';
import 'package:frontend/routes/postRoutes.dart';
import 'package:frontend/routes/spaceRoutes.dart';
import 'package:frontend/stores/store.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final _router = GoRouter(routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (context, state) {
          return FutureBuilder<String?>(
              future: Store.secure.read(key: "jwt"),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const Home();
                }
                return const Login();
              });
        },
        routes: [
          SpaceRoutes().getSpaceRoute(),
          AuthRoute().getSignupRoute(),
          AuthRoute().getLoginRoute()
        ]),
  ]);

  @override
  Widget build(BuildContext context) {
    var theme = const ColorScheme.light(
        secondary: Colors.black,
        primaryContainer: Colors.white,
        primary: Colors.blueGrey);
    return MaterialApp.router(
        theme: ThemeData(
            // Define the default brightness and colors.
            colorScheme: theme),
        routerConfig: _router);
  }
}
