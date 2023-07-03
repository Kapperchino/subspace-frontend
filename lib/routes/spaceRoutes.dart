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
          return FutureBuilder<SpaceView>(
              future: getHomePage(parentId, spaceName),
              builder: (context, AsyncSnapshot<SpaceView> snapshot) {
                if (snapshot.hasData) {
                  final space = snapshot.data!.space;
                  final list = snapshot.data!.posts;
                  final posts = list
                      .map((val) => PostCard(
                          topic: val.topic,
                          content: val.content,
                          userName: val.posterName,
                          body: val.body,
                          contentType: val.type,
                          likes: val.upVotes,
                          spaceId: val.spaceId,
                          parentSpaceId: space.parentId,
                          spaceName: space.name,
                          posterId: val.posterId,
                          created: val.created,
                          id: val.id,
                          dislikes: val.downVotes))
                      .toList();
                  //TODO: add user count
                  return Subspace(
                      name: spaceName!,
                      discription: space.description,
                      id: space.id,
                      users: 0,
                      items: posts);
                } else {
                  return const CircularProgressIndicator();
                }
              });
        });
  }

  Future<SpaceView> getHomePage(int parentId, String? spaceName) async {
    final token = await Store.secure.read(key: 'jwt');
    final spaceInfo = await http.get(
      Uri.http("localhost:3000", '/spaces',
          {'name': spaceName, 'parentId': '$parentId'}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    final space = Space.fromJson(jsonDecode(spaceInfo.body));
    final spaceId = space.id;
    final res = await http.get(
      Uri.http("localhost:3000", '/posts', {'space': '$spaceId'}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return SpaceView(space: space, posts: List.empty());
      }
      final List<dynamic> list = jsonDecode(res.body);
      var output = List<Post>.empty(growable: true);
      for (final json in list) {
        output.add(Post.fromJson(json));
      }
      return SpaceView(space: space, posts: output);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
