import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/post.dart';
import 'package:frontend/stores/store.dart';
import 'package:frontend/subspace/subspace.dart';
import 'package:http/http.dart' as http;

import '../models/space.dart';
import '../models/spaceView.dart';
import '../posts/postcard.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Subspace(name: "root", parentId: 0);
  }
}
