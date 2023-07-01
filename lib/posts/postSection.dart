import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/models/commentRequest.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/posts/voteWidget.dart';
import 'package:frontend/posts/voteWidgetFlat.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../models/appUser.dart';
import '../stores/store.dart';

class PostSection extends StatefulWidget {
  const PostSection(
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
  State<PostSection> createState() {
    return _PostState(topic, body, userName, content, spaceId, spaceName,
        parentSpaceId, likes, dislikes, posterId, contentType, id, created);
  }
}

class _PostState extends State<PostSection> {
  bool started = false;
  double commentHeight = 0.0;
  final textController = TextEditingController();

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

  _PostState(
      this.topic,
      this.body,
      this.userName,
      this.content,
      this.spaceId,
      this.spaceName,
      this.parentSpaceId,
      this.likes,
      this.dislikes,
      this.posterId,
      this.contentType,
      this.id,
      this.created);

  void comment() async {
    //commenting
    started = !started;
    commentHeight = 108;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: Card(
          margin: EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  topic,
                  style: Theme.of(context).textTheme.titleLarge,
                  textScaleFactor: 1.5,
                ),
              ),
              if (contentType == ContentType.text)
                const SizedBox(width: 0, height: 0),
              if (contentType == ContentType.picture)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    content,
                    width: 120,
                    height: 120,
                  ),
                ),
              Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Text(body)),
              Row(
                children: [
                  VoteWidgetFlat(likes: likes, dislikes: dislikes, postId: id),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (started) {
                            if (textController.text.isNotEmpty) {
                              final code =
                                  await postComment(textController.text);
                              textController.clear();
                              if (code == 200) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Comment posted')));
                                }
                              }
                            }
                          }
                          setState(() {
                            comment();
                          });
                        },
                        child: const Text('Comment'),
                      )),
                ],
              )
            ],
          ),
        )),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: started ? 100 : 0,
          curve: Curves.easeInOutCubicEmphasized,
          padding: EdgeInsets.only(top: 12, right: padding, left: padding),
          child: TextField(
            autofocus: false,
            maxLines: 3,
            controller: textController,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Comment',
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).cardColor),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<int> postComment(String comment) async {
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.post(
      Uri.parse('http://localhost:3000/comments'),
      body: jsonEncode(CommentRequest(
        postId: id,
        posterId: user.id,
        body: comment,
      ).toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }
}
