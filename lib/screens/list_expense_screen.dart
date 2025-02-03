import 'dart:convert';

import 'package:expense_tracker/api_constan.dart';
import 'package:expense_tracker/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  final _storage = FlutterSecureStorage();
  List<dynamic> _expenses = [];

  Future<void> _fetchExpenses() async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http
        .get(Uri.parse('${ApiConstant.baseUrl}/api/expense'), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      setState(() {
        _expenses = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Expense')),
        body: ListView.builder(
          itemCount: _expenses.length,
          itemBuilder: (context, index) {
            final expense = _expenses[index];
            return ListTile(
              title: Text('${expense['category']}: \$${expense['amount']}'),
              subtitle: Text('Date: ${expense['date']}'),
              trailing: IconButton(
                onPressed: () async {
                  final token = await _storage.read(key: 'jwt_token');
                  final response = await http.delete(
                      Uri.parse(
                          '${ApiConstant.baseUrl}/api/expense/${expense['id']}'),
                      headers: {
                        'Authorization': 'Bearer $token',
                      });
                  if (response.statusCode == 200) {
                    _fetchExpenses();
                  }
                },
                icon: Icon(Icons.delete),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddExpenseScreen()),
            );
          },
          child: Icon(Icons.add),
        ));
  }
}
