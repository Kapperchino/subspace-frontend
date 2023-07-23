
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/posting/postingBloc.dart';
import 'package:frontend/posts/cubit/posting/postingEvent.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';
import 'package:frontend/subspace/postCreationWidget.dart';
import 'package:frontend/subspace/postFileWidget.dart';
import 'package:frontend/subspace/postLinkWdiget.dart';
import 'package:go_router/go_router.dart';

class PostingWidget extends StatefulWidget {
  final int spaceId;
  const PostingWidget({super.key, required this.spaceId});

  @override
  State<StatefulWidget> createState() {
    return _PostingState(spaceId);
  }
}

class _PostingState extends State<PostingWidget> {
  final TextEditingController controllerTopic = TextEditingController();
  final TextEditingController controllerBody = TextEditingController();
  final TextEditingController controllerLink = TextEditingController();
  final int spaceId;

  _PostingState(this.spaceId);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 0.0);
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        centerTitle: true,
        pinned: false,
        snap: false,
        floating: false,
        expandedHeight: 200.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(10),
          child: Container(
              padding: EdgeInsets.only(right: padding, bottom: 10),
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () async {
                  context.read<PostingBloc>().add(PostPressed(
                      body: controllerBody.text,
                      topic: controllerTopic.text,
                      content: controllerLink.text,
                      spaceId: spaceId));
                },
                child: const Text('Post'),
              )),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        flexibleSpace: const FlexibleSpaceBar(
          title: Text("Create Post"),
          background: FlutterLogo(),
          titlePadding: EdgeInsets.all(50),
        ),
      ),
      BlocListener<PostingBloc, PostingState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state.status == PostingStatus.success) {
            controllerBody.clear();
            controllerTopic.clear();
            controllerLink.clear();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green, content: Text('Post created')));
            context.pop();
          } else if (state.status == PostingStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red, content: Text('Error input')));
          }
        },
        child: const SliverToBoxAdapter(child: SizedBox()),
      ),
      BlocBuilder<PostingBloc, PostingState>(builder: (context, state) {
        return DefaultTabController(
            length: 3,
            child: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    onTap: (value) {
                      controllerBody.clear();
                      controllerTopic.clear();
                      controllerLink.clear();
                      switch (value) {
                        case 0:
                          context
                              .read<PostingBloc>()
                              .add(const ModeChanged(PostingMode.text));
                        case 1:
                          context
                              .read<PostingBloc>()
                              .add(const ModeChanged(PostingMode.upload));
                        case 2:
                          context
                              .read<PostingBloc>()
                              .add(const ModeChanged(PostingMode.link));
                      }
                    },
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.post_add_rounded),
                            Text("Post")
                          ],
                        ),
                      ),
                      Tab(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_rounded),
                          Text("Photo")
                        ],
                      )),
                      Tab(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.link), Text("Link")],
                      )),
                    ],
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size.fromHeight(300)),
                    child: TabBarView(
                      clipBehavior: Clip.hardEdge,
                      children: [
                        PostCreationWidget(
                            controllderBody: controllerBody,
                            controllerTopic: controllerTopic),
                        PostFileWidget(
                            controllderBody: controllerBody,
                            controllerTopic: controllerTopic),
                        PostLinkWidget(
                            controllerLink: controllerLink,
                            controllderBody: controllerBody,
                            controllerTopic: controllerTopic),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      })
    ]));
  }
}
