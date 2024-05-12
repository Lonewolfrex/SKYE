import 'package:flutter/material.dart';
import 'package:skye/screens/screen0_landing.dart';
import 'package:skye/screens/screen1_add_expense.dart';
import 'package:skye/screens/screen2_expense_categories.dart';
import 'package:skye/screens/screen3_view_expenditure_report.dart';
import 'package:skye/utils/app_colors.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        hintColor: AppColors.accentColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LandingScreen(),
        '/addExpense': (context) => AddExpenseScreen(),
        '/ExpenseCategory': (context) => ExpenseCategoryScreen(),
        '/viewMyExpense': (context) => ViewMyExpenseScreen(),
      },
    );
  }
}
