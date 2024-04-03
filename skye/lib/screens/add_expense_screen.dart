import 'package:flutter/material.dart';
import '../listed/expense_categories.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _selectedCategory = '';
  String? _selectedSubcategory = '';
  double _expenseAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCategory.isNotEmpty ? _selectedCategory : 'Select Category',
              hint: Text('Select Category'),
              items: expenseCategories.map((category) {
                return DropdownMenuItem<String>(
                  value: category.name,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _selectedSubcategory = ''; // Reset the subcategory when category changes
                });
              },
            ),
            if (_selectedCategory.isNotEmpty && _selectedCategory != 'Select Category')
              DropdownButtonFormField<String>(
                value: _selectedSubcategory?.isNotEmpty ?? false ? _selectedSubcategory! : 'Select SubCategory',
                hint: Text('Select Subcategory'),
                items: expenseCategories
                    .firstWhere((category) => category.name == _selectedCategory)
                    .subcategories
                    .map((subcategory) {
                  return DropdownMenuItem<String>(
                    value: subcategory,
                    child: Text(subcategory),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSubcategory = value!;
                  });
                },
              ),

            if (_selectedSubcategory?.isNotEmpty ?? false)
              ElevatedButton(
                onPressed: () {
                  _showAmountPrompt();
                },
                child: Text('Enter Amount'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAmountPrompt() async {
    final TextEditingController _amountController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Expense Amount'),
          content: TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Amount'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _expenseAmount = double.tryParse(_amountController.text) ?? 0.0;
                });
                _showConfirmationDialog();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Expense Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Category: $_selectedCategory'),
              Text('Subcategory: $_selectedSubcategory'),
              Text('Amount: $_expenseAmount'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveExpense();
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _saveExpense() {
    // Implement logic to save the expense
    // You can pass the expense details to the expense_report_screen.dart
    // or save it to a database for persistence
  }
}
