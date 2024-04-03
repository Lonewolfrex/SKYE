// main.dart

import 'package:flutter/material.dart';
import 'screens/landing_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/update_category_screen.dart';
import 'screens/expense_report_screen.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(), // Landing screen route
        '/add_expense': (context) => AddExpenseScreen(), // Add expense screen route
        '/update_category': (context) => UpdateCategoryScreen(), // Update category screen route
        '/expense_report': (context) => ExpenseReportScreen(), // Expense report screen route
      },
    );
  }
}
