// widgets/category_dropdown.dart

import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?>? onChanged;

  CategoryDropdown({this.selectedCategory, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedCategory,
      onChanged: onChanged,
      items: ['Food', 'Transport', 'Utilities', 'Entertainment'].map((String category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
    );
  }
}
