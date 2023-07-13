import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../posts/cubit/posting/postingBloc.dart';
import '../posts/cubit/posting/postingEvent.dart';

class PostFileWidget extends StatelessWidget {
  const PostFileWidget(
      {super.key,
      required this.controllderBody,
      required this.controllerTopic});

  final TextEditingController controllderBody;
  final TextEditingController controllerTopic;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: padding),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Flexible(
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
            child: Container(
                padding: const EdgeInsets.only(left: 10),
                alignment: Alignment.centerLeft,
                child: OutlinedButton(
                    onPressed: () async {
                      if (context.mounted) {
                        final picker = ImagePicker();
                        final pic =
                            await picker.pickImage(source: ImageSource.gallery);
                        context.read<PostingBloc>().add(FileChanged(pic));
                      }
                    },
                    child: const Text("Upload photo")))),
        Flexible(
            flex: 2,
            child: TextField(
              autofocus: false,
              maxLines: 5,
              controller: controllderBody,
              decoration: InputDecoration(
                filled: true,
                hintText: 'Body',
                contentPadding: const EdgeInsets.only(left: 14.0, top: 8.0),
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
