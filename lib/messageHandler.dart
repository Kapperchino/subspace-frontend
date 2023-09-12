import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/mainapp.dart';
import 'package:frontend/models/mentionNotification.dart';
import 'package:frontend/models/replyNotification.dart';

import 'package:go_router/go_router.dart';
import 'package:localstore/localstore.dart';

class MessageHandler {
  static final MessageHandler _singleton = MessageHandler._internal();

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onBackgroundMessage((message) async {
      final db = Localstore.instance;
      if (message.data.isEmpty) {
        return;
      }
      if (message.data["fromUserId"] != null) {
        final fromUserId = int.parse(message.data["fromUserId"]);
        final toUserId = int.parse(message.data["toUserId"]);
        final postId = int.parse(message.data["postId"]);
        final title = message.notification?.title;
        final body = message.notification?.body;
        final id = db.collection("notification-mentions").doc().id;
        await db.collection("notification-mentions").doc(id).set(
            MentionNotification(
                    toUserId: toUserId,
                    postId: postId,
                    fromUserId: fromUserId,
                    sentDate: message.sentTime ?? DateTime.now(),
                    title: title ?? "",
                    body: body ?? "",
                    key: id)
                .toJson());
      }

      if (message.data["spaceId"] != null) {
        final spaceId = int.parse(message.data["spaceId"]);
        final postId = int.parse(message.data["postId"]);
        final commentId = int.parse(message.data["commentId"]);
        final title = message.notification?.title;
        final body = message.notification?.body;
        final id = db.collection("notification-reply").doc().id;
        await db.collection("notification-reply").doc(id).set(ReplyNotification(
                key: id,
                spaceId: spaceId,
                postId: postId,
                commentId: commentId,
                sentDate: message.sentTime ?? DateTime.now(),
                title: title ?? "",
                body: body ?? "")
            .toJson());
      }
    });
  }

  void _handleMessage(RemoteMessage message) {
    final spaceId = message.data["spaceId"];
    final postId = message.data["postId"];
    rootNavigatorKey.currentContext?.push("/s/$spaceId/SubSpace/p/$postId");
  }

  factory MessageHandler() {
    return _singleton;
  }

  MessageHandler._internal() {
    setupInteractedMessage();
  }
}
