import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/models/postRequest.dart';
import 'package:frontend/subspace/postCreationWidget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/subspace/postLinkWdiget.dart';
import 'package:get_storage/get_storage.dart';

import '../config.dart';
import '../models/appUser.dart';
import '../posts/cubit/space/spaceBlock.dart';
import '../posts/cubit/space/spaceState.dart';
import '../posts/postcard.dart';
import '../stores/store.dart';
import 'package:http/http.dart' as http;

class Subspace extends StatefulWidget {
  const Subspace({super.key, required this.name, required this.parentId});

  final String name;
  final int parentId;

  @override
  State<StatefulWidget> createState() {
    return _SubSpaceState(parentId: parentId, name: name);
  }
}

class _SubSpaceState extends State<Subspace> {
  _SubSpaceState({
    required this.parentId,
    required this.name,
  });

  final String name;
  final int parentId;
  Future<List<PostCard>>? items;
  int id = -1;
  int count = 0;
  bool started = false;

  final TextEditingController controllerTopic = TextEditingController();
  final TextEditingController controllerBody = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
            height: started ? 190 : 0,
            curve: Curves.easeInOutCubicEmphasized,
            child: DefaultTabController(
              length: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    onTap: (value) {
                      controllerBody.clear();
                      controllerTopic.clear();
                    },
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.post_add_rounded),
                            Text("Post")
                          ],
                        ),
                      ),
                      Tab(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.link), Text("Link")],
                      )),
                    ],
                  ),
                  Flexible(
                    child: TabBarView(
                      children: [
                        PostCreationWidget(
                            controllderBody: controllerBody,
                            controllerTopic: controllerTopic),
                        PostLinkWidget(
                            controllderBody: controllerBody,
                            controllerTopic: controllerTopic),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        BlocBuilder<SpaceBloc, SpaceState>(
          builder: (context, state) {
            switch (state.status) {
              case SpaceStatus.failure:
                return const SliverToBoxAdapter(
                    child: Center(child: Text('failed to fetch posts')));
              case SpaceStatus.success:
                if (state.posts.isEmpty) {
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('no posts')));
                }
                return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        if (index >= state.posts.length) {
                          return const SliverToBoxAdapter(
                              child: BottomLoader());
                        }
                        return PostCard(data: state.posts[index]);
                      }, childCount: state.posts.length),
                    ));
              case SpaceStatus.initial:
                return const SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
      ]),
    );
  }

  Future<int> postPost(String body, String topic,
      {String content = "", ContentType contentType = ContentType.text}) async {
    final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
    final token = await Store.secure.read(key: 'jwt');
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/posts'),
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
