import 'dart:math';

import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../cubit/posting/postingBloc.dart';
import '../cubit/posting/postingEvent.dart';

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
    final padding = max((width - 600) / 2, 8.0);
    return Card(
      margin: EdgeInsets.symmetric(horizontal: padding),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Flexible(
            child: Padding(
                padding: const EdgeInsets.all(5),
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
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: DetectableTextField(
                  autofocus: false,
                  maxLines: 5,
                  detectionRegExp: detectionRegExp()!,
                  controller: controllderBody,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'Body',
                    contentPadding: const EdgeInsets.only(left: 14.0, top: 8.0),
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
                )))
      ]),
    );
  }
}
