import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/stores/store.dart';
import 'package:frontend/subspace/post.dart';
import 'package:frontend/subspace/postcard.dart';
import 'package:frontend/subspace/subspace.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
        future: getHomePage(),
        builder: (context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;
            final posts = list
                ?.map((val) => PostCard(
                    topic: val.topic,
                    content: val.content,
                    userName: val.posterName,
                    body: val.body,
                    contentType: val.type,
                    likes: val.upVotes,
                    dislikes: val.downVotes))
                .toList();
            //TODO: add user count
            return Subspace(
                name: "home",
                discription: "the home page",
                users: 0,
                items: posts!);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Future<List<Post>> getHomePage() async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.http("localhost:3000", '/posts', {'spaceId': '1'}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return List<Post>.empty();
      }
      final List<dynamic> list = jsonDecode(res.body);
      var output = List<Post>.empty(growable: true);
      for (final json in list) {
        output.add(Post.fromJson(json));
      }
      return output;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
