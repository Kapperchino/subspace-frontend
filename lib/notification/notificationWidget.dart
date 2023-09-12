import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/notification/notificationBloc.dart';
import 'package:frontend/cubit/notification/notificationEvent.dart';
import 'package:frontend/cubit/notification/notificationState.dart';
import 'package:frontend/models/mentionNotification.dart';
import 'package:frontend/models/replyNotification.dart';
import 'package:go_router/go_router.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget(
      {super.key,
      this.replyNotification,
      this.mentionNotification,
      required this.sendTime});
  final ReplyNotification? replyNotification;
  final MentionNotification? mentionNotification;
  final DateTime sendTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
      return Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () async {
              if (replyNotification != null) {
                context
                    .read<NotificationBloc>()
                    .add(NotificationSaw(id: replyNotification!.key));
                context.push("/s/1/SubSpace/p/${replyNotification!.postId}");
              }
              if (mentionNotification != null) {
                context
                    .read<NotificationBloc>()
                    .add(MentionSaw(id: mentionNotification!.key));
                context.push("/s/1/SubSpace/p/${mentionNotification!.postId}");
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(flex: 8, child: getListTile()),
              ],
            ),
          ));
    });
  }

  Widget getListTile() {
    if (replyNotification != null) {
      return ListTile(
        title: Text(replyNotification!.title),
        subtitle: Text(replyNotification!.body),
      );
    }
    if (mentionNotification != null) {
      return ListTile(
        title: Text(mentionNotification!.title),
        subtitle: Text(mentionNotification!.body),
      );
    }
    return const SizedBox();
  }
}
