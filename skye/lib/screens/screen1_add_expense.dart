import 'package:flutter/material.dart';

class AddExpenseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input fields for expense details
            Text('Expense Amount:'),
            TextFormField(
              keyboardType: TextInputType.number,
              // Expense amount input field
            ),
            SizedBox(height: 10),
            // Other input fields (category, subcategory, date, etc.)
            ElevatedButton(
              onPressed: () {
                // Save expense to SQLite database
              },
              child: Text('Save Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
