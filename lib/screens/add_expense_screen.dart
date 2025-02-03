import 'package:intl/intl.dart';
import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:expense_tracker/utils/snack_bar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  final _notesController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitExpense() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<ExpenseProvider>(context, listen: false);
    bool success = await provider.addExpense(
      double.parse(_amountController.text),
      _selectedCategory,
      DateFormat('yyyy-MM-dd').format(_selectedDate),
      _notesController.text.isEmpty ? null : _notesController.text,
    );
    if (success) {
      showSnackBar(context, 'Expense added successfully',
          backgroundColor: Colors.green);
      _amountController.clear();
      _notesController.clear();

      setState(() {
        _selectedCategory = 'Food';
        _selectedDate = DateTime.now();
      });
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showSnackBar(context, 'Failed to add expense',
          backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: ['Food', 'Transport', 'Entertainment', 'Others']
                    .map((category) => DropdownMenuItem(
                        value: category, child: Text(category)))
                    .toList(),
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (newValue) =>
                    setState(() => _selectedCategory = newValue!),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                      'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                  IconButton(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today))
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                decoration:
                    const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitExpense,
                child: const Text('Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
