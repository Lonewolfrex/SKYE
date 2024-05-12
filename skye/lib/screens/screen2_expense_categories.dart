import 'package:flutter/material.dart';
import '../utils/ExpenseCategoryUtil.dart'; // Import the ExpenseCategoryUtil class

class ExpenseCategoryScreen extends StatefulWidget {
  @override
  _ExpenseCategoryScreenState createState() => _ExpenseCategoryScreenState();
}

class _ExpenseCategoryScreenState extends State<ExpenseCategoryScreen> {
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    List<Map<String, dynamic>> categories = await ExpenseCategoryUtil.getAllCategories();
    setState(() {
      _categories = categories;
    });
  }



  // Method to handle adding a new category
  void _addNewCategory() async {
    String? newCategoryName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Add New Category'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Enter Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (newCategoryName != null && newCategoryName.trim().isNotEmpty) {
      // Check for duplicate category name
      if (_categories.any((category) => category['category_name'] == newCategoryName)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Duplicate Category'),
              content: Text('Category name "$newCategoryName" already exists.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        bool success = await ExpenseCategoryUtil.addCategory(newCategoryName, []);
        if (success) {
          // Add the new category to the existing list of categories
          _categories.add({
            'category_name': newCategoryName,
            'subcategories': [],
          });
          // Sort the categories alphabetically by name
          _categories.sort((a, b) => a['category_name'].compareTo(b['category_name']));
          setState(() {
            _categories = _categories;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add category. An error occurred.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Empty Category'),
            content: Text('Category name cannot be empty.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // Method to handle deleting a category
  void _deleteCategory(String categoryName) async {
    bool success = await ExpenseCategoryUtil.deleteCategory(categoryName);
    if (success) {
      setState(() {
        _categories.removeWhere((category) => category['category_name'] == categoryName);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete category. An error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSubcategories(String categoryName) async {
    try {
      List<String> subcategories = await ExpenseCategoryUtil.getSubcategoriesForCategory(categoryName);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Subcategories for $categoryName'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: subcategories.map((subcategory) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(subcategory),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editSubcategory(categoryName, subcategory);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteSubcategory(categoryName, subcategory);
                        },
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error fetching subcategories: $e');
    }
  }

  void _editSubcategory(String categoryName, String subcategoryName) async {
    String? editedSubcategoryName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController(text: subcategoryName);
        return AlertDialog(
          title: Text('Edit Subcategory'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Enter Subcategory Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (editedSubcategoryName != null && editedSubcategoryName.trim().isNotEmpty) {
      try {
        bool success = await ExpenseCategoryUtil.updateSubcategory(categoryName, subcategoryName, editedSubcategoryName);
        if (success) {
          setState(() {
            int index = _categories.indexWhere((category) => category['category_name'] == categoryName);
            if (index != -1) {
              List<String> subcategories = _categories[index]['subcategories'];
              int subcategoryIndex = subcategories.indexOf(subcategoryName);
              if (subcategoryIndex != -1) {
                subcategories[subcategoryIndex] = editedSubcategoryName;
                _categories[index]['subcategories'] = subcategories;
              }
            }
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to edit subcategory. An error occurred.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error editing subcategory: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Subcategory name cannot be empty.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteSubcategory(String categoryName, String subcategoryName) async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Subcategory'),
          content: Text('Are you sure you want to delete the subcategory "$subcategoryName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmed) {
      try {
        bool success = await ExpenseCategoryUtil.deleteSubcategory(categoryName, subcategoryName);
        if (success) {
          // Fetch updated categories after successful deletion
          await _fetchCategories();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Subcategory "$subcategoryName" deleted successfully.'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete subcategory. An error occurred.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        print('Error deleting subcategory: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete subcategory. An error occurred.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addNewCategory,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Category')),
                DataColumn(label: Text('Actions')),
              ],
              rows: _categories.map((category) {
                return DataRow(
                  cells: [
                    DataCell(Text(category['category_name'] ?? '')),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Implement edit functionality
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            _showSubcategories(category['category_name']);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteCategory(category['category_name']);
                          },
                        ),
                      ],
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

