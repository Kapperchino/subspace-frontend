import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

class Store {
  static final secure = new FlutterSecureStorage();

  static Future<String?> getJwt() {
    if (!kIsWeb) {
      return secure.read(key: "jwt");
    }
    return Future.sync(() => GetStorage().read("jwt"));
  }

  static Future<void> saveJwt(String jwt) {
    if (!kIsWeb) {
      return secure.write(key: "jwt", value: jwt);
    }
    return Future.sync(() => GetStorage().write("jwt", jwt));
  }
}
