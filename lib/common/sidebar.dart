
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/util/userUtil.dart';
import 'package:go_router/go_router.dart';

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
                            backgroundImage: snapshot.data!.$2,
                            backgroundColor: Colors.blue,
                            maxRadius: 70,
                          ));
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
                FutureBuilder<AppUser?>(
                    future: UserUtil.getAppUser(),
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
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              UserUtil.deleteUser();
              await Store.secure.delete(key: "jwt");
              context.go("/login");
            },
          ),
        ],
      ),
    );
  }

  Future<(AppUser, ImageProvider)> getProfilePic() async {
    final AppUser? user = await UserUtil.getAppUser();
    final defaultProfileIndex = user!.id % 6;
    if (user.picture == null) {
      return (
        user,
        AssetImage('assets/default_profile_$defaultProfileIndex.png')
      );
    }
    return (user, CachedNetworkImageProvider(user.picture!.url));
  }
}
