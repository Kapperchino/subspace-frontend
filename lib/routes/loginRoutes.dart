import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/intro/login.dart';
import 'package:frontend/intro/signup.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/space.dart';
import '../posts/postcard.dart';
import '../stores/store.dart';
import '../subspace/subspace.dart';

class AuthRoute {
  GoRoute getSignupRoute() {
    return GoRoute(path: 'signup', builder: (context, state) => const Signup());
  }

  GoRoute getLoginRoute() {
    return GoRoute(path: 'login', builder: (context, state) => const Login());
  }
}
