import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/appUser.dart';
import 'package:frontend/models/appUserRes.dart';
import 'package:frontend/models/device.dart';
import 'package:frontend/models/login.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../config.dart';
import '../stores/store.dart';
import 'package:http/http.dart' as http;

import '../util/deviceUtil.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 150),
              Text(
                "Welcome back",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              ConstrainedBox(
                constraints:
                    const BoxConstraints.expand(width: 600, height: 70),
                child: TextFormField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    filled: true,
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onEditingComplete: () => _focusNodePassword.requestFocus(),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter username.";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints:
                    const BoxConstraints.expand(width: 600, height: 70),
                child: TextFormField(
                  controller: _controllerPassword,
                  focusNode: _focusNodePassword,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    prefixIcon: const Icon(Icons.password_outlined),
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: _obscurePassword
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter password.";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  ConstrainedBox(
                      constraints:
                          const BoxConstraints.expand(width: 600, height: 50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final res = await login();
                            if (res == 200) {
                              context.go("/");
                            } else if (res == 404 || res == 400) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Invalid email or password"),
                                backgroundColor: Colors.red,
                              ));
                            }
                          }
                        },
                        child: const Text("Login"),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          _formKey.currentState?.reset();
                          context.push("/signup");
                        },
                        child: const Text("Signup"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> login() async {
    Device? device;
    if (!kIsWeb) {
      if (Platform.isIOS || Platform.isAndroid) {
        final deviceId = await getId();
        final registration = await FirebaseMessaging.instance.getToken();
        device = Device(deviceId: deviceId!, registration: registration!);
      }
    }
    var login = LogIn(
        email: _controllerEmail.text.toLowerCase(),
        password: _controllerPassword.text,
        device: device);
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/auth/login'),
      body: jsonEncode(login.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      final user = AppUserRes.fromJson(jsonDecode(res.body));
      DateTime expirationDate = JwtDecoder.getExpirationDate(user.token);
      await Store.secure.delete(key: "jwt");
      await Store.secure.write(key: "jwt", value: user.token);
      await GetStorage().write("expire", expirationDate.toIso8601String());
      await GetStorage().write(
          "user",
          jsonEncode(AppUser(
                  id: user.id,
                  displayName: user.displayName,
                  email: user.email,
                  picture: user.picture)
              .toJson()));
      return res.statusCode;
    } else {
      return res.statusCode;
    }
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
