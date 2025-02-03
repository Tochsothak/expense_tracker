import 'dart:convert';

import 'package:expense_tracker/api_constan.dart';
import 'package:expense_tracker/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ExpenseService {
  Future<bool> addExpense(
      double amount, String category, String date, String? notes) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return false;

    try {
      final response =
          await http.post(Uri.parse('${ApiConstant.baseUrl}/api/expense/add'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                "amount": amount,
                "category": category,
                "date": date,
                "notes": notes,
              }));
      if (response.statusCode == 401) {
        // Token expired,  try  refreshing
        final newToken = await AuthService().refreshToken();

        if (newToken == null) return false;

        // Retry the request with the new token
        final retryResponse = await http.post(
            Uri.parse('${ApiConstant.baseUrl}/api/expense/add'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $newToken'
            },
            body: jsonEncode({
              "amount": amount,
              "category": category,
              "date": date,
              "notes": notes,
            }));
        return retryResponse.statusCode == 201;
      }
      return response.statusCode == 201;
    } catch (e, stackTrace) {
      print('Error adding expense: $e');
      return false;
    }
  }

  // Fetch expenses
  Future<List<Map<String, dynamic>>> fetchExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print("No token found");
      throw Exception("User not logged in");
    }

    try {
      final response = await http.get(
        Uri.parse('${ApiConstant.baseUrl}/api/expense'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic responseBody = jsonDecode(response.body);

        // Ensure the response is a List
        if (responseBody is List) {
          return List<Map<String, dynamic>>.from(responseBody);
        } else {
          throw Exception('Invalid response format: Expected an array');
        }
      } else {
        throw Exception('Failed to fetch expenses');
      }
    } catch (e) {
      print('Error fetching expenses: $e');
      throw e;
    }
  }

  // Delete expense
  Future<bool> deleteExpense(String expenseId) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return false;
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstant.baseUrl}/api/expense/$expenseId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting expense: $e');
      return false;
    }
  }
}
