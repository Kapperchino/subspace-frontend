import 'package:frontend/mainapp.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';

void main() async {
  await GetStorage.init();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(MainApp());
}
