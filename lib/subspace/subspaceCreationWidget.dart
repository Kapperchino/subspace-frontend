import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/spaceCreation/spaceCreationBloc.dart';
import 'package:frontend/cubit/spaceCreation/spaceCreationEvent.dart';
import 'package:frontend/cubit/spaceCreation/spaceCreationState.dart';
import 'package:go_router/go_router.dart';

class SubspaceCreationWidget extends StatefulWidget {
  final int parentId;
  const SubspaceCreationWidget({super.key, required this.parentId});

  @override
  State<StatefulWidget> createState() {
    return _SubspaceCreationWidget(parentId);
  }
}

class _SubspaceCreationWidget extends State<SubspaceCreationWidget> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDiscription = TextEditingController();
  final TextEditingController controllerLink = TextEditingController();
  final int parentId;

  _SubspaceCreationWidget(this.parentId);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 0.0);
    var fit = BoxFit.none;
    if (kIsWeb) {
      fit = BoxFit.fitWidth;
    } else {
      if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
        fit = BoxFit.fitWidth;
      } else {
        fit = BoxFit.fitHeight;
      }
    }
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
                  context.read<SpaceCreationBloc>().add(SpaceCreated(
                      name: controllerName.text,
                      discription: controllerDiscription.text,
                      picture: controllerLink.text));
                },
                child: const Text('Post'),
              )),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        flexibleSpace: FlexibleSpaceBar(
          title: const Text("Create SubSpace"),
          background: Image.asset(
            "assets/create_subspace_background.png",
            fit: fit,
          ),
          titlePadding: const EdgeInsets.all(50),
        ),
      ),
      BlocListener<SpaceCreationBloc, SpaceCreationState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state.status == SpaceCreationStatus.success) {
            controllerName.clear();
            controllerDiscription.clear();
            controllerLink.clear();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green, content: Text('Space created')));
            context.pop();
          } else if (state.status == SpaceCreationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.red, content: Text('Error input')));
          }
        },
        child: const SliverToBoxAdapter(child: SizedBox()),
      ),
      BlocBuilder<SpaceCreationBloc, SpaceCreationState>(
          builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                    constraints:
                        BoxConstraints.loose(const Size.fromHeight(300)),
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsetsDirectional.all(5),
                                child: TextField(
                                  autofocus: false,
                                  maxLines: 1,
                                  controller: controllerName,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Space Name',
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).cardColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).cardColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ))),
                        Flexible(
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: TextField(
                                  autofocus: false,
                                  maxLines: 7,
                                  controller: controllerDiscription,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Discription',
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).cardColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).cardColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ))),
                        Flexible(
                            child: Padding(
                                padding: const EdgeInsetsDirectional.all(5),
                                child: TextField(
                                  autofocus: false,
                                  maxLines: 7,
                                  controller: controllerLink,
                                  decoration: InputDecoration(
                                    filled: true,
                                    hintText: 'Picture',
                                    contentPadding: const EdgeInsets.only(
                                        left: 14.0, bottom: 8.0, top: 8.0),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).cardColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).cardColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                )))
                      ]),
                    )),
              ],
            ),
          ),
        );
      })
    ]));
  }
}
