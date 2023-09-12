import 'package:flutter/material.dart';
import 'package:frontend/posts/postPage.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:go_router/go_router.dart';

import '../stores/store.dart';

class PostRoutes {
  GoRoute getPostRoute() {
    return GoRoute(
        path: 'p/:id',
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
          final subspaceName = state.pathParameters['subSpace']!;
          return PostPage(
            id: int.parse(id!),
            spaceName: subspaceName,
          );
        });
  }
}
