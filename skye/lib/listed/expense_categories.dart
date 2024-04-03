// expense_categories.dart

import 'package:flutter/material.dart';

class ExpenseCategory {
  final String name;
  final Color color;
  final List<String> subcategories;

  ExpenseCategory({
    required this.name,
    required this.color,
    required this.subcategories,
  });
}

List<ExpenseCategory> expenseCategories = [
  ExpenseCategory(
    name: 'Travel',
    color: Colors.blue,
    subcategories: ['Flight', 'Hotel', 'Transportation', 'Misc'],
  ),
  ExpenseCategory(
    name: 'Food',
    color: Colors.green,
    subcategories: ['Restaurant', 'Groceries', 'Fast Food', 'Misc_sub'],
  ),
  // Add more categories as needed
];

// Add a function to get the default category
ExpenseCategory getDefaultCategory() {
  return ExpenseCategory(
    name: 'Select Category',
    color: Colors.grey,
    subcategories: [],
  );
}
