import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/postRequest.dart';
import 'package:frontend/subspace/postCreationWidget.dart';
import 'package:get_storage/get_storage.dart';

import '../models/appUser.dart';
import '../posts/postcard.dart';
import '../stores/store.dart';
import 'package:http/http.dart' as http;

class Subspace extends StatefulWidget {
  const Subspace(
      {super.key,
      required this.name,
      required this.discription,
      required this.users,
      required this.id,
      required this.items});

  final String name;
  final String discription;
  final int id;
  final int users;
  final List<PostCard> items;

  @override
  State<StatefulWidget> createState() {
    return _SubSpaceState(
        name: name,
        discription: discription,
        users: users,
        items: items,
        id: id);
  }
}

class _SubSpaceState extends State<Subspace> {
  _SubSpaceState(
      {required this.name,
      required this.discription,
      required this.users,
      required this.items,
      required this.id});

  final String name;
  final String discription;
  final int users;
  final int id;
  final List<PostCard> items;
  bool started = false;

  final TextEditingController controllerTopic = TextEditingController();
  final TextEditingController controllerBody = TextEditingController();

  onClick() {
    started = !started;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          snap: false,
          floating: false,
          expandedHeight: 160.0,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(10),
              child: Padding(
                padding: EdgeInsets.only(right: padding, bottom: 10),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (started && controllerBody.text.isNotEmpty) {
                        int code = await postPost(
                            controllerBody.text, controllerTopic.text);
                        controllerBody.clear();
                        controllerTopic.clear();
                        if (code == 200) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Post created')));
                          }
                        }
                      }
                      setState(() => onClick());
                    },
                    child: const Text('Post'),
                  ),
                ),
              )),
          backgroundColor: Theme.of(context).colorScheme.background,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(name),
            background: const FlutterLogo(),
            titlePadding: const EdgeInsets.all(50),
          ),
        ),
        SliverToBoxAdapter(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: started ? 150 : 0,
            curve: Curves.easeInOutCubicEmphasized,
            child: PostCreationWidget(
              controllderBody: controllerBody,
              controllerTopic: controllerTopic,
            ),
          ),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: items[index],
            );
          }, childCount: items.length),
        )
      ]),
    );
  }

  Future<int> postPost(String body, String topic,
      {String content = "", ContentType contentType = ContentType.text}) async {
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.post(
      Uri.parse('http://localhost:3000/posts'),
      body: jsonEncode(PostRequest(
        content: content,
        topic: topic,
        spaceId: id,
        posterId: user.id,
        body: body,
      ).toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    return res.statusCode;
  }
}
