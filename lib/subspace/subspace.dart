import 'package:flutter/material.dart';

import '../posts/postcard.dart';

class Subspace extends StatelessWidget {
  const Subspace(
      {super.key,
      required this.name,
      required this.discription,
      required this.users,
      required this.items});

  final String name;
  final String discription;
  final int users;
  final List<PostCard> items;

  @override
  Widget build(BuildContext context) {
    const title = 'Mixed List';

    return Scaffold(
      body: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: items.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          return Row(
            children: [
              Expanded(flex: 1, child: Container()),
              ConstrainedBox(
                constraints:
                    const BoxConstraints(minWidth: 500, maxWidth: 1000),
                child: Expanded(child: items[index]),
              ),
              Expanded(flex: 1, child: Container()),
            ],
          );
        },
      ),
    );
  }
}
