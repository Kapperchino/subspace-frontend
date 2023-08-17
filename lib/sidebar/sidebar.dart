import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

import '../cubit/space/spaceBlock.dart';
import '../cubit/space/spaceState.dart';
import '../models/appUser.dart';
import '../stores/store.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SafeArea(
              child: SizedBox(
            height: 210,
            child: DrawerHeader(
              child: Column(children: [
                FutureBuilder<(AppUser, ImageProvider)>(
                  future: getProfilePic(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return InkWell(
                          onTap: () {
                            final id = snapshot.data!.$1.id;
                            context.push("/u/$id");
                          },
                          child: CircleAvatar(
                            foregroundImage: snapshot.data!.$2,
                            backgroundColor: Colors.blue,
                            maxRadius: 70,
                          ));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                FutureBuilder<AppUser>(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(snapshot.data!.displayName));
                      }
                      return const CircularProgressIndicator();
                    })
              ]),
            ),
          )),
          if (GoRouter.of(context).location.startsWith('/s/'))
            BlocBuilder<SpaceBloc, SpaceState>(
                builder: (context, state) => ListTile(
                      title: const Text('Create Subspace'),
                      onTap: () {
                        context.push("/create/space/${state.spaceId}");
                      },
                    )),
          ListTile(
            title: const Text('Subscriptions'),
            onTap: () {
              context.push("/subscriptions");
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              await GetStorage().remove("expire");
              await GetStorage().remove("user");
              await Store.secure.delete(key: "jwt");
              context.go("/login");
            },
          ),
        ],
      ),
    );
  }

  Future<(AppUser, ImageProvider)> getProfilePic() async {
    final AppUser user = await getUser();
    final defaultProfileIndex = user.id % 6;
    if (user.picture == null) {
      return (
        user,
        AssetImage('assets/default_profile_$defaultProfileIndex.png')
      );
    }
    return (user, CachedNetworkImageProvider(user.picture!.url));
  }

  Future<AppUser> getUser() async {
    return AppUser.fromJson(jsonDecode(await GetStorage().read("user")));
  }
}
