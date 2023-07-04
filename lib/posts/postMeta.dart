import 'package:flutter/material.dart';

class PostMeta extends StatelessWidget {
  const PostMeta({
    super.key,
    required this.userName,
    required this.posterId,
    required this.created,
    required this.spaceName,
  });

  final String userName;
  final int posterId;
  final DateTime created;
  final String spaceName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
            child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 5),
                  child: TextButton(
                    child: Text(userName),
                    onPressed: () {},
                  ),
                ))),
        if (spaceName != 'root')
          Flexible(
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, left: 5),
                    child: TextButton(
                      child: Text('s/$spaceName'),
                      onPressed: () {},
                    ),
                  ))),
        const Spacer(),
        Flexible(
            child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, right: 5),
                  child: Text("${getTime(created)} ago"),
                )))
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
