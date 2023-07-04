import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/routes/postRoutes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/space.dart';
import '../models/spaceView.dart';
import '../posts/postcard.dart';
import '../stores/store.dart';
import '../subspace/subspace.dart';

class SpaceRoutes {
  GoRoute getSpaceRoute() {
    return GoRoute(
        path: 's/:parentSpace/:subSpace',
        redirect: (context, state) async {
          final jwt = await Store.secure.read(key: "jwt");
          if (jwt == null) {
            return '/login';
          }
          return null;
        },
        routes: [PostRoutes().getPostRoute()],
        builder: (BuildContext context, GoRouterState state) {
          final spaceName = state.pathParameters['subSpace'];
          final parentId = int.parse(state.pathParameters['parentSpace']!);
          return Subspace(
            name: spaceName!,
            parentId: parentId,
          );
        }
        //TODO: add user count
        );
  }
}
