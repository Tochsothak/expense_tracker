import 'package:expense_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final _storage = FlutterSecureStorage();

  Future<void> _logout(BuildContext context) async {
    await _storage.delete(key: 'jwt_token');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
                onPressed: () {
                  _logout(context);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: Center(
          child: Text('Welcome to the Expense Tracker App!'),
        ));
  }
}
