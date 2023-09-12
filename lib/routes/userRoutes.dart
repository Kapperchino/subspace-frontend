import 'package:flutter/material.dart';
import 'package:frontend/user/userPage.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:go_router/go_router.dart';

import '../stores/store.dart';

class UserRoutes {
  GoRoute getUserRoute() {
    return GoRoute(
        path: '/u/:id',
        redirect: (context, state) async {
          DateTime? expire = await UserUtil.getExpire();
          final jwt = await Store.secure.read(key: "jwt");
          if (jwt == null) {
            return "/login";
          }
          if (expire != null) {
            if (expire.isBefore(DateTime.now())) {
              return "/login";
            }
            return null;
          }
          return "/login";
        },
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'];
          return UserPage(
            userId: int.parse(id!),
          );
        });
  }
}
