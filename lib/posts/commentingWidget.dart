import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/posts/cubit/commenting/commentingBloc.dart';
import 'package:frontend/posts/cubit/commenting/commentingEvent.dart';
import 'package:frontend/posts/cubit/commenting/commentingState.dart';

class CommentingWidget extends StatelessWidget {
  const CommentingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final padding = max((width - 800) / 2, 0.0);
    return BlocBuilder<CommentingBloc, CommentingState>(
        builder: (context, state) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: state.status == CommentingStaus.started ||
                state.status == CommentingStaus.failure
            ? 100
            : 0,
        curve: Curves.easeInOutCubicEmphasized,
        padding: EdgeInsets.only(
            top: 12,
            right: state.isPostComment ? padding : 10,
            left: state.isPostComment ? padding : 10),
        child: TextField(
          autofocus: false,
          maxLines: 3,
          onChanged: (comment) => context
              .read<CommentingBloc>()
              .add(CommentChanged(comment: comment)),
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
