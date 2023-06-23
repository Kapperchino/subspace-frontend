import 'package:flutter/material.dart';
import 'package:frontend/subspace/postcard.dart';
import 'package:frontend/subspace/subspace.dart';

import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var list = List<PostCard>.empty(growable: true);
    for (int x = 0; x < 10; x++) {
      list.add(const PostCard(
          topic: "joe biden", content: "joe biden", likes: 100, dislikes: 0));
    }
    return Subspace(
        name: "home", discription: "joe biden's house", users: 0, items: list);
  }
}
