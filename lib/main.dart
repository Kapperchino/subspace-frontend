import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:frontend/mainapp.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/updateDeviceReq.dart';
import 'package:frontend/stores/store.dart';
import 'package:frontend/util/deviceUtil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config.dart';
import 'firebase_options.dart';
import 'models/appUser.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await GetStorage.init();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  if (Platform.isAndroid || Platform.isIOS) {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
      String? expire = GetStorage().read("expire");
      if (expire != null) {
        final time = DateTime.parse(expire);
        if (time.isAfter(DateTime.now())) {
          return;
        }
        final AppUser user = AppUser.fromJson(await GetStorage().read("user"));
        final token = await Store.secure.read(key: 'jwt');
        final deviceId = await getId();
        final res = await http.put(Uri.parse('${Config.baseUrl}/devices/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(UpdateDeviceReq(
                deviceId: deviceId!, registration: fcmToken, userId: user.id)));
      }
    }).onError((err) {
      log(err);
    });
  }

  runApp(MainApp());
}
