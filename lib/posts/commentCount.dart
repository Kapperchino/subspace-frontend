import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/vote/voteBloc.dart';
import 'package:frontend/cubit/vote/voteEvent.dart';
import 'package:frontend/cubit/vote/voteState.dart';

class CommentCount extends StatelessWidget {
  const CommentCount({super.key, required this.count});

  final int count;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
            elevation: 5,
            padding: EdgeInsets.zero,
            minimumSize: const Size(65, 35),
            textStyle:
                TextStyle(color: Theme.of(context).colorScheme.secondary)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.comment_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 23,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
            Text(
              count.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
            ),
          ],
        ));
  }
}
