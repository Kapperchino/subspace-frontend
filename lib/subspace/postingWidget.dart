import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/posting/postingBloc.dart';
import 'package:frontend/posts/cubit/posting/postingState.dart';
import 'package:frontend/subspace/postCreationWidget.dart';
import 'package:frontend/subspace/postLinkWdiget.dart';


class PostingWidget extends StatelessWidget {
  const PostingWidget({
    super.key,
    required this.controllerTopic,
    required this.controllerBody,
  });

  final TextEditingController controllerTopic;
  final TextEditingController controllerBody;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostingBloc, PostingState>(builder: (context, state) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: state.status == PostingStatus.started ||
                state.status == PostingStatus.failure
            ? 190
            : 0,
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
                      children: [Icon(Icons.post_add_rounded), Text("Post")],
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
      );
    });
  }
}
