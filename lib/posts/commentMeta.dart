
import 'package:flutter/material.dart';

class CommentMeta extends StatelessWidget {
  const CommentMeta({
    super.key,
    required this.userName,
    required this.posterId,
    required this.created,
  });

  final String userName;
  final int posterId;
  final DateTime created;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 5, left: 5),
          child: Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              child: Text(userName),
              onPressed: () {},
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 5, right: 5),
          child: Align(
            alignment: Alignment.topRight,
            child: Text("${getTime(created)} ago"),
          ),
        )
      ],
    );
  }

  String getTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inDays >= 365) {
      final years = diff.inDays / 365;
      if (years == 1) {
        return '$years year';
      }
      return '$years years';
    }
    if (diff.inDays >= 1) {
      final days = diff.inDays;
      if (days == 1) {
        return '$days day';
      }
      return '$days days';
    }
    if (diff.inHours >= 1) {
      final hours = diff.inHours;
      if (hours == 1) {
        return '$hours hour';
      }
      return '$hours hours';
    }

    if (diff.inMinutes >= 1) {
      final minutes = diff.inMinutes;
      if (minutes == 1) {
        return '$minutes minute';
      }
      return '$minutes minutes';
    }

    final seconds = diff.inSeconds;
    return '$seconds seconds';
  }
}
