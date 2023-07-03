import 'package:flutter/material.dart';
import 'package:frontend/intro/home.dart';
import 'package:frontend/intro/login.dart';
import 'package:frontend/routes/loginRoutes.dart';
import 'package:frontend/routes/postRoutes.dart';
import 'package:frontend/routes/spaceRoutes.dart';
import 'package:frontend/stores/store.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final _router = GoRouter(routes: <RouteBase>[
    GoRoute(
        path: '/',
        builder: (context, state) {
          String? expire = GetStorage().read("expire");
          if (expire != null) {
            final time = DateTime.parse(expire);
            if (time.isAfter(DateTime.now())) {
              return const Home();
            }
          }
          return const Login();
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
