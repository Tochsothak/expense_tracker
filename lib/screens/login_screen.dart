import 'dart:convert';

import 'package:expense_tracker/api_constan.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/sign_up_screen.dart';
import 'package:expense_tracker/screens/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final response =
          await http.post(Uri.parse('${ApiConstant.baseUrl}/api/auth/login'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'email': _emailController.text,
                'password': _passwordController.text,
              }));

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        await _storage.write(key: 'jwt_token', value: token);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        showSnackBar(context, 'Invalid Credentials',
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    _login();
                  },
                  child: const Text('Login')),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => SignupScreen())));
                  },
                  child: const Text('Don\'t have an account? Sign up now !'))
            ],
          ),
        ),
      ),
    );
  }
}
