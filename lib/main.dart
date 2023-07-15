import 'package:frontend/mainapp.dart';
import 'package:flutter/material.dart';
import 'package:frontend/stores/store.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(MainApp());
}
