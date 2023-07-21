import 'package:flutter/material.dart';
import 'package:frontend/routes/postRoutes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../stores/store.dart';
import '../subspace/spacePage.dart';

class SpaceRoutes {
  GoRoute getSpaceRoute() {
    return GoRoute(
        path: '/s/:parentSpace/:subSpace',
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
        routes: [PostRoutes().getPostRoute()],
        builder: (BuildContext context, GoRouterState state) {
          final spaceName = state.pathParameters['subSpace'];
          final parentId = int.parse(state.pathParameters['parentSpace']!);
          return SpacePage(
            spaceName: spaceName!,
            parentId: parentId,
          );
        }
        //TODO: add user count
        );
  }
}
