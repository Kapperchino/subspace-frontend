import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/posting/postingBloc.dart';
import 'package:frontend/posts/cubit/posting/postingEvent.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';
import 'package:frontend/subspace/postCreationWidget.dart';
import 'package:frontend/subspace/postFileWidget.dart';
import 'package:frontend/subspace/postLinkWdiget.dart';
import 'package:get_storage/get_storage.dart';

class PostingWidget extends StatelessWidget {
  const PostingWidget(
      {super.key,
      required this.controllerTopic,
      required this.controllerBody,
      required this.controllerLink});

  final TextEditingController controllerTopic;
  final TextEditingController controllerBody;
  final TextEditingController controllerLink;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostingBloc, PostingState>(builder: (context, state) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: state.status == PostingStatus.started ||
                state.status == PostingStatus.failure
            ? 300
            : 0,
        curve: Curves.easeInOutCubicEmphasized,
        child: DefaultTabController(
          length: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                onTap: (value) {
                  if (value == 0 && state.mode == PostingMode.link) {
                    controllerBody.clear();
                    controllerTopic.clear();
                    controllerLink.clear();
                  } else if (value == 1 && state.mode == PostingMode.text) {
                    controllerBody.clear();
                    controllerTopic.clear();
                    controllerLink.clear();
                  }
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Icon(Icons.post_add_rounded), Text("Post")],
                    ),
                  ),
                  Tab(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_rounded),
                      Text("Photo")
                    ],
                  )),
                  Tab(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.link), Text("Link")],
                  )),
                ],
              ),
              Expanded(
                child: TabBarView(
                  clipBehavior: Clip.antiAlias,
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
              )
            ],
          ),
        ),
      );
    });
  }
}
