import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/comment.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/comment.dart';
import 'package:frontend/posts/commentSection.dart';
import 'package:frontend/posts/postSection.dart';
import 'package:frontend/posts/voteWidget.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../stores/store.dart';

class PostWidget extends StatelessWidget {
  const PostWidget(
      {super.key,
      required this.topic,
      this.content = "",
      this.contentType = ContentType.text,
      required this.likes,
      required this.body,
      required this.userName,
      required this.spaceId,
      required this.posterId,
      required this.dislikes,
      required this.parentSpaceId,
      required this.spaceName,
      required this.id,
      required this.created});

  final String topic;
  final String body;
  final String userName;
  final String content;
  final int spaceId;
  final String spaceName;
  final int parentSpaceId;
  final int likes;
  final int dislikes;
  final int posterId;
  final ContentType contentType;
  final int id;
  final DateTime created;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: Column(
          children: [
            PostSection(
                topic: topic,
                likes: likes,
                body: body,
                userName: userName,
                spaceId: spaceId,
                posterId: posterId,
                dislikes: dislikes,
                parentSpaceId: parentSpaceId,
                spaceName: spaceName,
                id: id,
                created: created),
            FutureBuilder<List<CommentWidget>>(
              future: getComments(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final comments = snapshot.data!;
                  return CommentSection(items: comments);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        ));
  }

  Future<List<CommentWidget>> getComments() async {
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.get(
      Uri.http("localhost:3000", '/comments', {'postId': '$id'}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      if (res.body.isEmpty || res.body == 'null') {
        return List.empty();
      }
      final List<dynamic> list = jsonDecode(res.body);
      final List<CommentWidget> comments = list.map((e) {
        final comment = Comment.fromJson(e);
        return CommentWidget(
            likes: comment.upVotes,
            body: comment.body,
            userName: comment.posterName,
            posterId: comment.posterId,
            postId: comment.postId,
            dislikes: comment.downVotes,
            id: comment.id,
            created: comment.created);
      }).toList(growable: false);
      return comments;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
