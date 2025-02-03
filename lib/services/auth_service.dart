import 'dart:convert';
import 'package:expense_tracker/api_constan.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //Login
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/api/auth/login'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['token']);
        await prefs.setString(
            'refreshToken', data['refreshToken']); // Store refresh token
        return data['token']; // Return Jwt token if login is successful
      } else {
        return null; // return null if login fails
      }
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // Sign up
  Future<bool> signup(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstant.baseUrl}/api/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );
      print('Response status : ${response.statusCode}');
      print('Response Body: ${response.body}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Signup Error: $e');
      return false;
    }
  }

  // Refresh token
  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refreshToken');

      // Store refreshToken during login
      if (refreshToken == null) return null;
      final resposne = await http.post(
          Uri.parse('${ApiConstant.baseUrl}/api/auth/refresh'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'refreshToken': refreshToken}));

      if (resposne.statusCode == 200) {
        final data = jsonDecode(resposne.body);
        final newToken = data['token'];
        await prefs.setString('token', newToken); //Save new token
        return newToken;
      } else {
        return null;
      }
    } catch (e) {
      print('Error refresh token: $e');
      return null;
    }
  }

  // //Log out
  // Future<void> logout() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('token');
  // }
}
