// screens/expense_list_screen.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../widgets/expense_item.dart';

class ExpenseListScreen extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseListScreen({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense List'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (BuildContext context, int index) {
          return ExpenseItem(expense: expenses[index]);
        },
      ),
    );
  }
}
