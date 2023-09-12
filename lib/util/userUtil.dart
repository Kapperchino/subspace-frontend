import 'dart:convert';
import 'dart:ffi';

import 'package:frontend/models/appUser.dart';
import 'package:localstore/localstore.dart';

class UserUtil {
  static Future<AppUser?> getAppUser() async {
    final db = Localstore.instance;
    final userMap = await db.collection("user").doc("main").get();
    if (userMap == null) {
      return null;
    }
    return AppUser.fromJson(userMap);
  }

  static Future<DateTime?> getExpire() async {
    final db = Localstore.instance;
    final expire = await db.collection("expire").doc("key").get();
    if (expire == null) {
      return null;
    }
    return DateTime.parse(expire["time"]);
  }

  static Future<void> deleteUser() async {
    final db = Localstore.instance;
    await db.collection("expire").delete();
    await db.collection("user").delete();
  }

  static Future<void> saveUser(AppUser user) async {
    final db = Localstore.instance;
    await db.collection("user").doc("main").set(user.toJson());
  }

  static Future<void> saveExpire(DateTime expire) async {
    final db = Localstore.instance;
    await db
        .collection("expire")
        .doc("key")
        .set({"time": expire.toIso8601String()});
  }
}
