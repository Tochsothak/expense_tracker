import 'dart:convert';

import 'package:expense_tracker/api_constan.dart';
import 'package:expense_tracker/screens/home_screen.dart';
import 'package:expense_tracker/screens/utils/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();
  final _storage = FlutterSecureStorage();

  Future<void> _addExpense() async {
    if (_formKey.currentState!.validate()) {
      final token = await _storage.read(key: 'jwt_token');
      final response =
          await http.post(Uri.parse('${ApiConstant.baseUrl}/api/expense/add'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                'amount': double.parse(_amountController.text),
                'category': _categoryController.text,
                'date': _dateController.text,
                'notes': _notesController.text,
              }));
      if (response.statusCode == 200) {
        showSnackBar(context, 'Expense added successfully',
            backgroundColor: Colors.green);
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        showSnackBar(context, 'Failed to add expense',
            backgroundColor: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Category'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration:
                    const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addExpense,
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
