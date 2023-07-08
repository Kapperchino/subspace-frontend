import 'dart:math';

import 'package:flutter/material.dart';

class PostLinkWidget extends StatelessWidget {
  const PostLinkWidget(
      {super.key,
      required this.controllderBody,
      required this.controllerTopic,
      required this.controllerLink});

  final TextEditingController controllderBody;
  final TextEditingController controllerTopic;
  final TextEditingController controllerLink;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: TextField(
                      autofocus: false,
                      maxLines: 1,
                      controller: controllerTopic,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Topic',
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ))),
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Flexible(
                        child: TextField(
                      autofocus: false,
                      maxLines: 1,
                      controller: controllerLink,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Link',
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, bottom: 8.0, top: 8.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).cardColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )))),
            Flexible(
              flex: 2,
                child: TextField(
              autofocus: false,
              maxLines: 5,
              controller: controllderBody,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Body',
                contentPadding:
                    const EdgeInsets.only(left: 14.0, top: 8.0),
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
        ));
  }
}
