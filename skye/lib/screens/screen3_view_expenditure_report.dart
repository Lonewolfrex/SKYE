import 'package:flutter/material.dart';

class ViewMyExpenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View My Expense'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expense list with options to filter, search, edit, delete
          ],
        ),
      ),
    );
  }
}
