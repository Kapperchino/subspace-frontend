import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/postCardData.dart';
import 'package:go_router/go_router.dart';

import '../models/post.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({super.key, required this.time});

  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Text("${getTime(time)} ago");
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
