import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/signUp.dart';
import 'package:frontend/util/userUtil.dart';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../models/appUser.dart';
import '../models/appUserRes.dart';
import '../stores/store.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerUserAt = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword =
      TextEditingController();

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Text(
                "Register",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              Text(
                "Create your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 35),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.expand(width: 600, height: 70),
                  child: TextFormField(
                    controller: _controllerDisplayName,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "Display Name",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username.";
                      }
                      return null;
                    },
                    onEditingComplete: () => _focusNodeEmail.requestFocus(),
                  )),
              const SizedBox(height: 10),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.expand(width: 600, height: 70),
                  child: TextFormField(
                    controller: _controllerUserAt,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: "User @",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter username.";
                      }
                      return null;
                    },
                    onEditingComplete: () => _focusNodeEmail.requestFocus(),
                  )),
              const SizedBox(height: 10),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.expand(width: 600, height: 70),
                  child: TextFormField(
                    controller: _controllerEmail,
                    focusNode: _focusNodeEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email.";
                      } else if (!(value.contains('@') &&
                          value.contains('.'))) {
                        return "Invalid email";
                      }
                      return null;
                    },
                    onEditingComplete: () => _focusNodePassword.requestFocus(),
                  )),
              const SizedBox(height: 10),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.expand(width: 600, height: 70),
                  child: TextFormField(
                    controller: _controllerPassword,
                    obscureText: _obscurePassword,
                    focusNode: _focusNodePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
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
                      } else if (value.length < 8) {
                        return "Password must be at least 8 character.";
                      }
                      return null;
                    },
                    onEditingComplete: () =>
                        _focusNodeConfirmPassword.requestFocus(),
                  )),
              const SizedBox(height: 10),
              ConstrainedBox(
                  constraints:
                      const BoxConstraints.expand(width: 600, height: 70),
                  child: TextFormField(
                    controller: _controllerConFirmPassword,
                    obscureText: _obscurePassword,
                    focusNode: _focusNodeConfirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
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
                      } else if (value != _controllerPassword.text) {
                        return "Password doesn't match.";
                      }
                      return null;
                    },
                  )),
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
                            final res = await register();
                            if (!context.mounted) return;
                            if (res.statusCode == 200) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text("Registered Successfully"),
                                ),
                              );
                              _formKey.currentState?.reset();
                              context.pop();
                            } else if (res.statusCode == 409) {
                              var message = "";
                              if (res.body == "email") {
                                message = "Email already registered";
                              } else if (res.body == "display_name") {
                                message = "Display name already taken";
                              } else {
                                message = "Error with the server";
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(message),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Register"),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () => context.go("/login"),
                        child: const Text("Login"),
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

  Future<http.Response> register() async {
    final req = SignUpRequest(
        password: _controllerPassword.text,
        displayName: _controllerDisplayName.text,
        email: _controllerEmail.text.toLowerCase(),
        address: _controllerUserAt.text.toLowerCase());
    final res = await http.post(
      Uri.parse('${Config.baseUrl}/auth/user'),
      body: jsonEncode(req.toJson()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (res.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      final user = AppUserRes.fromJson(jsonDecode(res.body));
      await Store.secure.write(key: "jwt", value: user.token);
      await UserUtil.saveUser(AppUser(
          id: user.id,
          displayName: user.displayName,
          email: user.email,
          address: user.address));
      return res;
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      return res;
    }
  }

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    _controllerDisplayName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
    super.dispose();
  }
}
