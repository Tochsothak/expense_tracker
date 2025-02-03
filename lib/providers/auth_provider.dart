import 'package:expense_tracker/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _token;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _loadToken(); // Load token when provider initializes
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _token = await _authService.login(email, password);
    if (_token != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token!);
      print('Token saved : $_token');
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> signup(String username, String email, String password) async {
    await _authService.signup(username, email, password);
    notifyListeners();
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  void logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    notifyListeners();

    // Navigate to the login screen after logout
    navigatorKey.currentState?.pushReplacementNamed('/login');
  }

  String? get token => _token;
}
