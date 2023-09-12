import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Store {
  static const secure = FlutterSecureStorage();

  static Future<String?> getJwt() {
    return secure.read(key: "jwt");
  }

  static Future<void> saveJwt(String jwt) {
    return secure.write(key: "jwt", value: jwt);
  }
}
