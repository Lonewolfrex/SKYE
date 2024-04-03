// widgets/expense_item.dart

import 'package:flutter/material.dart';
import '../models/expense.dart';

class ExpenseItem extends StatelessWidget {
  final Expense expense;

  ExpenseItem({required this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.category),
      subtitle: Text('Amount: \$${expense.amount.toString()}'),
    );
  }
}
