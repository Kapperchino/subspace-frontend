import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/mainapp.dart';
import 'package:flutter/material.dart';
import 'package:frontend/messageHandler.dart';
import 'package:frontend/models/updateDeviceReq.dart';
import 'package:frontend/stores/store.dart';
import 'package:frontend/util/deviceUtil.dart';
import 'package:frontend/util/userUtil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'config.dart';
import 'firebase_options.dart';
import 'models/appUser.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  GoRouter.optionURLReflectsImperativeAPIs = true;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationCacheDirectory(),
  );

  if (!kIsWeb) {
    if (Platform.isAndroid || Platform.isIOS) {
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

      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) async {
        final expire = await UserUtil.getExpire();
        if (expire != null) {
          if (expire.isAfter(DateTime.now())) {
            return;
          }
          final AppUser? user = await UserUtil.getAppUser();
          if (user == null) {
            return;
          }
          final token = await Store.secure.read(key: 'jwt');
          final deviceId = await getId();
          if (deviceId != null) {
            await http.put(Uri.parse('${Config.baseUrl}/devices/'),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                  'Authorization': 'Bearer $token',
                },
                body: jsonEncode(UpdateDeviceReq(
                    deviceId: deviceId,
                    registration: fcmToken,
                    userId: user.id)));
          }
        }
      }).onError((err) {
        log(err);
      });
      MessageHandler();
    }
  }
  runApp(MainApp());
}
