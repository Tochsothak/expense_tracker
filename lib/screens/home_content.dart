import 'package:expense_tracker/providers/auth_provider.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracker/providers/expense_provider.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    return RefreshIndicator(
      onRefresh: () async {
        await expenseProvider.fetchExpenses();
      },
      child: ListView.builder(
          itemCount: expenseProvider.expenses.length,
          itemBuilder: (context, index) {
            final expense = expenseProvider.expenses[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text('Amount: \$${expense['amount']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category: ${expense['category']}'),
                    Text('Date: ${expense['date']}'),
                    if (expense['notes'] != null)
                      Text('Notes : ${expense['notes']}'),
                  ],
                ),
                trailing: IconButton(
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Delete Expense'),
                                content: const Text(
                                    'Are you sure you want to delete this expense? '),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel')),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete'))
                                ],
                              ));
                      if (shouldDelete == true) {
                        await expenseProvider.deleteExpense(expense['id']);
                      }
                    },
                    icon: const Icon(Icons.delete)),
              ),
            );
          }),
    );
  }
}
