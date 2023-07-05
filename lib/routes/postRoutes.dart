import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/posts/post.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/post.dart';
import '../stores/store.dart';

class PostRoutes {
  GoRoute getPostRoute() {
    return GoRoute(
        path: 'p/:id',
        redirect: (context, state) async {
          final jwt = await Store.secure.read(key: "jwt");
          if (jwt == null) {
            return '/login';
          }
          return null;
        },
        builder: (BuildContext context, GoRouterState state) {
          final id = state.pathParameters['id'];
          final subspaceName = state.pathParameters['subSpace']!;
          final parentId = int.parse(state.pathParameters['parentSpace']!);

          return FutureBuilder<Post>(
              future: getPost(int.parse(id!)),
              builder: (context, AsyncSnapshot<Post> snapshot) {
                if (snapshot.hasData) {
                  final val = snapshot.data!;
                  return PostWidget(
                      topic: val.topic,
                      spaceName: subspaceName,
                      parentSpaceId: parentId,
                      content: val.content,
                      userName: val.posterName,
                      body: val.body,
                      contentType: val.type,
                      likes: val.upVotes,
                      spaceId: val.spaceId,
                      posterId: val.posterId,
                      created: val.created,
                      id: val.id,
                      dislikes: val.downVotes);
                  //TODO: add user count
                } else {
                  return const CircularProgressIndicator();
                }
              });
        });
  }

  Future<Post> getPost(int id) async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.parse('${Config.baseUrl}/posts/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Post.fromJson(jsonDecode(res.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
