import 'package:expense_tracker/services/expense_service.dart';
import 'package:flutter/material.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  bool _isLoading = false;
  List<Map<String, dynamic>> _expenses = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get expenses => _expenses;

  Future<bool> addExpense(
      double amount, String category, String date, String? notes) async {
    _isLoading = true;
    notifyListeners(); // Notify UI to show loading
    try {
      bool success =
          await _expenseService.addExpense(amount, category, date, notes);

      _isLoading = false;
      notifyListeners(); // Notify UI to remove loading
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error adding expense: $e');
      return false;
    }
  }

  // Fetch expenses
  Future<void> fetchExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _expenses = await _expenseService.fetchExpenses();
    } catch (e) {
      print('Error fetching expenses: $e');
      _expenses = []; // Clear expenses in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Delete expense
  Future<bool> deleteExpense(String expenseId) async {
    _isLoading = true;
    notifyListeners();
    try {
      bool success = await _expenseService.deleteExpense(expenseId);
      if (success) {
        _expenses.removeWhere((expense) => expense['id'] == expenseId);
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print('Error deleting expense $e');
      return false;
    }
  }
}
