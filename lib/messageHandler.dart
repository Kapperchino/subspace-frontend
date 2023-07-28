import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:frontend/mainapp.dart';
import 'package:frontend/routes/createRoutes.dart';
import 'package:frontend/routes/loginRoutes.dart';
import 'package:frontend/routes/searchRoute.dart';
import 'package:frontend/routes/spaceRoutes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

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
  }

  void _handleMessage(RemoteMessage message) {
    final spaceId = message.data["spaceId"];
    final postId = message.data["postId"];
    rootNavigatorKey.currentContext!.push("/s/$spaceId/SubSpace/p/$postId");
  }

  factory MessageHandler() {
    return _singleton;
  }

  MessageHandler._internal() {
    setupInteractedMessage();
  }
}
