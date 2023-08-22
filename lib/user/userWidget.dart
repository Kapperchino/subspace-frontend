import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/buttomLoader.dart';
import 'package:frontend/cubit/userPage/userPageBloc.dart';
import 'package:frontend/cubit/userPage/userPageEvent.dart';
import 'package:frontend/cubit/userPage/userPageState.dart';
import 'package:frontend/models/pictureMeta.dart';
import 'package:frontend/cubit/sorting/sortBloc.dart';
import 'package:frontend/cubit/sorting/sortState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/models/userMeta.dart';
import 'package:frontend/subspace/sortPostsDaysWidget.dart';
import 'package:frontend/subspace/sortPostsWidget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

import '../models/appUser.dart';
import '../posts/postCardWrapper.dart';
import '../sidebar/sidebar.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({super.key, required this.userId});

  final int userId;

  @override
  State<StatefulWidget> createState() {
    return _UserWidgetState(userId: userId);
  }
}

class _UserWidgetState extends State<UserWidget> {
  _UserWidgetState({required this.userId});

  final int userId;
  AppUser? currentUser;

  @override
  void initState() {
    super.initState();
  }

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
      endDrawer: const SideBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<UserPageBloc>().add(UserPageFetched(userId: userId));
        },
        child: CustomScrollView(cacheExtent: 8500, slivers: <Widget>[
          BlocBuilder<UserPageBloc, UserPageState>(builder: (context, state) {
            return SliverAppBar(
              pinned: false,
              snap: false,
              floating: false,
              expandedHeight: 200,
              centerTitle: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              flexibleSpace: FlexibleSpaceBar(
                background: getImage(null, fit),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    SafeArea(
                        child: Stack(children: [
                      CircleAvatar(
                        foregroundImage: getUserImage(state.user),
                        backgroundColor: Colors.blue,
                        maxRadius: 60,
                      ),
                      if(isCurrentUser(userId))
                      Positioned(
                          left: 83,
                          child: ElevatedButton(
                            onPressed: () {
                              final picker = ImagePicker();
                              picker
                                  .pickImage(source: ImageSource.gallery)
                                  .then((pic) {
                                context
                                    .read<UserPageBloc>()
                                    .add(UserPagePicUpload(file: pic));
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              minimumSize: const Size(4, 4),
                              padding: const EdgeInsets.all(3),
                              backgroundColor: Colors.blue, // <-- Button color
                              foregroundColor: Colors.red, // <-- Splash color
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            ),
                          ))
                    ])),
                  ],
                ),
                titlePadding: const EdgeInsets.all(50),
              ),
            );
          }),
          BlocBuilder<UserPageBloc, UserPageState>(
            builder: (context, state) {
              return SliverToBoxAdapter(
                  child: Card(
                      color: Theme.of(context).colorScheme.background,
                      margin: EdgeInsets.symmetric(horizontal: padding),
                      child: Column(
                        children: [
                          BlocListener<UserPageBloc, UserPageState>(
                            listener: (context, state) {
                              if (state.bioStatus == BioEditStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Bio changed')));
                              } else if (state.bioStatus ==
                                  BioEditStatus.failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text('Failed to change Bio')));
                              }

                              if (state.picEditStatus ==
                                  PicEditStatus.success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text('Picture changed')));
                                context
                                    .read<UserPageBloc>()
                                    .add(UserPageFetched(userId: userId));
                              }

                              if (state.picEditStatus ==
                                  PicEditStatus.failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.red,
                                        content:
                                            Text('Failed to change picture')));
                              }
                            },
                            child: const SizedBox(),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Spacer(
                                flex: 2,
                              ),
                              Flexible(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      state.user?.displayName ?? "loading",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                    ),
                                  )),
                              const Spacer(),
                              if (isCurrentUser(state.user?.id))
                                Flexible(
                                    child: Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      onPressed: () {
                                        context
                                            .read<UserPageBloc>()
                                            .add(UserPageBioToggle());
                                      },
                                      icon: const Icon(Icons.edit)),
                                )),
                              if (!isCurrentUser(state.user?.id)) const Spacer()
                            ],
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                decoration: InputDecoration(
                                    enabled:
                                        state.bioStatus == BioEditStatus.edit,
                                    contentPadding: const EdgeInsets.all(10),
                                    disabledBorder: InputBorder.none,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20))),
                                controller: state.controller,
                                readOnly: state.bioStatus != BioEditStatus.edit,
                                minLines: 1,
                                maxLines: 3,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ))
                        ],
                      )));
            },
          ),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.only(left: padding, top: 0),
                    alignment: Alignment.topLeft,
                    child: const SortPostsWidget()),
                Container(
                    padding: const EdgeInsets.only(left: 5, top: 0),
                    alignment: Alignment.bottomLeft,
                    child: const SortPostsDaysWidget())
              ],
            ),
          ),
          BlocBuilder<UserPageBloc, UserPageState>(
            builder: (context, state) {
              switch (state.status) {
                case UserPageStatus.failure:
                  return const SliverToBoxAdapter(
                      child: Center(child: Text('failed to fetch posts')));
                case UserPageStatus.success:
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
                          return PostCardWrapper(
                              spaceName: state.posts[index].spaceName,
                              post: state.posts[index]);
                        }, childCount: state.posts.length),
                      ));
                case UserPageStatus.initial:
                  return const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()));
              }
            },
          ),
          BlocListener<SortBloc, SortState>(
            listenWhen: (previous, current) {
              return previous.status != current.status;
            },
            listener: (context, state) {
              context
                  .read<UserPageBloc>()
                  .add(UserPageSortChanged(sortState: state.status));
            },
            child: const SliverToBoxAdapter(child: SizedBox()),
          ),
          BlocListener<SortBloc, SortState>(
            listenWhen: (previous, current) {
              return previous.sortDays != current.sortDays;
            },
            listener: (context, state) {
              context
                  .read<UserPageBloc>()
                  .add(UserPageDaysSortChanged(sortDays: state.sortDays));
            },
            child: const SliverToBoxAdapter(child: SizedBox()),
          )
        ]),
      ),
    );
  }

  Widget getImage(PictureMeta? picture, BoxFit fit) {
    if (picture == null) {
      return Image.asset(
        "assets/default_space_background.png",
        fit: fit,
      );
    }
    return CachedNetworkImage(
      imageUrl: picture.url,
      placeholder: (context, url) => Image.memory(kTransparentImage),
      fit: fit,
    );
  }

  ImageProvider getUserImage(UserMeta? meta) {
    if (meta == null) {
      return const AssetImage('assets/default_profile_1.png');
    }
    final defaultProfileIndex = meta.id % 6;
    if (meta.picture == null) {
      return AssetImage('assets/default_profile_$defaultProfileIndex.png');
    }
    return CachedNetworkImageProvider(meta.picture!.url);
  }

  bool isCurrentUser(int? userId) {
    if (currentUser == null) {
      final AppUser user =
          AppUser.fromJson(jsonDecode(GetStorage().read("user")));
      currentUser = user;
      return user.id == userId;
    }
    return currentUser!.id == userId;
  }
}
