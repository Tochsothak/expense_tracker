import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/login_screen.dart';
import 'package:expense_tracker/screens/sign_up_screen.dart';
import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MyApp(initialRoute: '/splash'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Expense Tracker',
        initialRoute: initialRoute,
        routes: {
          '/splash': (context) => SplashScreen(),
          '/home': (context) => HomeScreen(),
          '/signup': (context) => SignupScreen(),
          '/login': (context) => LoginScreen(),
        },
      ),
    );
  }
}
