// screens/landing_screen.dart

import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Expense Tracker',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Track your expenses efficiently with our app. Choose an option below:',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to add expense screen
                Navigator.pushNamed(context, '/add_expense');
              },
              child: Text('Add Expense'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to update expense category screen
                Navigator.pushNamed(context, '/update_category');
              },
              child: Text('Update Expense Category'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Navigate to expense report screen
                Navigator.pushNamed(context, '/expense_report');
              },
              child: Text('Expense Report'),
            ),
          ],
        ),
      ),
    );
  }
}
