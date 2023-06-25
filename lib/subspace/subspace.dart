import 'package:flutter/material.dart';
import 'package:frontend/subspace/postcard.dart';

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

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title:  Text(name),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            return item;
          },
        ),
      ),
    );
  }
}
