import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final _storage = FlutterSecureStorage();
  final token = await _storage.read(key: 'jwt_token');

  runApp(MyApp(initialRoute: token != null ? '/home' : '/login'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(initialRoute: initialRoute, routes: {
      '/login': (context) => LoginScreen(),
      '/home': (context) => HomeScreen()
    });
  }
}
