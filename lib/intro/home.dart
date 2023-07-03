import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/stores/store.dart';
import 'package:frontend/subspace/subspace.dart';
import 'package:http/http.dart' as http;

import '../models/space.dart';
import '../models/spaceView.dart';
import '../posts/postcard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SpaceView>(
        future: getHomePage(),
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
                name: space.name,
                id: space.id,
                discription: space.description,
                users: 0,
                items: posts);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<SpaceView> getHomePage() async {
    final token = await Store.secure.read(key: 'jwt');
    final spaceInfo = await http.get(
      Uri.http("localhost:3000", '/spaces', {'name': 'root', 'parentId': '0'}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (spaceInfo.statusCode == 401) {
      return Future.error(401);
    }
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
