import 'package:expense_tracker/providers/expense_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final expenses = expenseProvider.expenses;

    // Group expense by category
    final Map<String, double> categoryTotals = {};
    for (var expense in expenses) {
      final category = expense['category'] ?? 'Unknown';
      final amount = (expense['amount'] ?? 0).toDouble();

      categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Analitics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: expenses.isEmpty
            ? Center(child: Text('No expenses to display'))
            : Column(
                children: [
                  const Text(
                    'Spending by Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PieChart(PieChartData(
                      sections: categoryTotals.entries.map((entry) {
                        return PieChartSectionData(
                          value: entry.value,
                          title:
                              '${entry.key}\n\$${entry.value.toStringAsFixed(2)}',
                          color: _getCategoryColor(entry.key),
                          radius: 60,
                          titleStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      }).toList(),
                    )),
                  ),
                ],
              ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food':
        return Colors.red.withOpacity(0.5);
      case 'Transport':
        return Colors.blue.withOpacity(0.5);
      case 'Entertainment':
        return Colors.green.withOpacity(0.5);
      default:
        return Colors.orange.withOpacity(0.5);
    }
  }
}
