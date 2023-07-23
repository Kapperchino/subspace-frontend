import 'dart:math';

import 'package:flutter/material.dart';

class PostCreationWidget extends StatelessWidget {
  const PostCreationWidget(
      {super.key,
      required this.controllderBody,
      required this.controllerTopic});

  final TextEditingController controllderBody;
  final TextEditingController controllerTopic;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 600) / 2, 0.0);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: padding),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(
          autofocus: false,
          maxLines: 1,
          controller: controllerTopic,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Topic',
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        Flexible(
            child: TextField(
          autofocus: false,
          maxLines: 7,
          controller: controllderBody,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Body',
            contentPadding:
                const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ))
      ]),
    );
  }
}
