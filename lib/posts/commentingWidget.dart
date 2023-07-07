import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/commenting/commentingBloc.dart';
import 'package:frontend/posts/cubit/commenting/commentingState.dart';


class CommentingWidget extends StatelessWidget {
  const CommentingWidget({
    super.key,
    required this.controllerComment,
  });

  final TextEditingController controllerComment;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 1000) / 2, 0.0);
    return BlocBuilder<CommentingBloc, CommentingState>(
        builder: (context, state) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: state.status == CommentingStaus.started ||
                state.status == CommentingStaus.failure
            ? 100
            : 0,
        curve: Curves.easeInOutCubicEmphasized,
        padding: EdgeInsets.only(top: 12, right: padding, left: padding),
        child: TextField(
          autofocus: false,
          maxLines: 3,
          controller: controllerComment,
          decoration: InputDecoration(
            filled: true,
            hintText: 'Comment',
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
      );
    });
  }
}
