// screens/update_category_screen.dart

import 'package:flutter/material.dart';

import '../cosmetics/color_palette.dart';

class UpdateCategoryScreen extends StatefulWidget {
  @override
  _UpdateCategoryScreenState createState() => _UpdateCategoryScreenState();
}

class _UpdateCategoryScreenState extends State<UpdateCategoryScreen> {
  List<Map<String, dynamic>> expenseCategories = [
    {'name': 'Travel', 'color': Colors.blue},
    {'name': 'Food', 'color': Colors.green},
    {'name': 'Tuition', 'color': Colors.orange},
    {'name': 'Utilities', 'color': Colors.purple},
    {'name': 'Groceries', 'color': Colors.red},
  ];

  TextEditingController _categoryController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Expense Category'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: expenseCategories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(expenseCategories[index]['name']),
                  leading: CircleAvatar(
                    backgroundColor: expenseCategories[index]['color'],
                    child: Text(
                      expenseCategories[index]['name'][0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editCategory(index);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _confirmDelete(index);
                        },
                      ),
                      DropdownButton<Color>(
                        value: expenseCategories[index]['color'],
                        onChanged: (Color? color) {
                          if (color != null) {
                            setState(() {
                              expenseCategories[index]['color'] = color;
                            });
                          }
                        },
                        items: _buildColorDropdownItems(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'New Category',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addCategory();
            },
            child: Text('Add Category'),
          ),
        ],
      ),
    );
  }

  void _addCategory() {
    String newCategory = _categoryController.text.trim();
    if (newCategory.isNotEmpty) {
      setState(() {
        expenseCategories.add({'name': newCategory, 'color': _selectedColor});
      });
      _categoryController.clear();
    }
  }

  void _editCategory(int index) {
    // Implement edit category functionality
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this category?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  expenseCategories.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
  List<DropdownMenuItem<Color>> _buildColorDropdownItems() {
    return colorPalette.map((Color color) {
      return DropdownMenuItem<Color>(
        value: color,
        child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      );
    }).toList();
  }
}
