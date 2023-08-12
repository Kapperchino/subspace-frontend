import 'package:flutter/material.dart';
import 'package:frontend/posts/postPage.dart';
import 'package:frontend/user/userPage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../stores/store.dart';

class UserRoutes {
  GoRoute getUserRoute() {
    return GoRoute(
        path: '/u/:id',
        redirect: (context, state) async {
          String? expire = GetStorage().read("expire");
          final jwt = await Store.secure.read(key: "jwt");
          if (jwt == null) {
            return "/login";
          }
          if (expire != null) {
            final time = DateTime.parse(expire);
            if (time.isBefore(DateTime.now())) {
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
