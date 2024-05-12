import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ExpenseCategoryUtil {
  static Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/expense_categories.json');

    // Check if the file exists, if not, copy the default JSON file from assets
    if (!await file.exists()) {
      try {
        // Read default file from assets
        ByteData data = await rootBundle.load('assets/expense_categories.json');
        List<int> bytes = data.buffer.asUint8List();

        // Write default file to application documents directory
        await file.writeAsBytes(bytes);
      } catch (e) {
        print('Error copying default file: $e');
      }
    }

    return file;
  }

  static Future<List<Map<String, dynamic>>> getUpdatedCategories() async {
    List<Map<String, dynamic>> categories = await getAllCategories();
    return categories;
  }
  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    try {
      // Read JSON data from the local file
      final file = await _getLocalFile();
      String jsonData = await file.readAsString();
      final parsedJson = jsonDecode(jsonData);
      final List<dynamic> categories = parsedJson['categories'];

      // Convert categories to a list of maps
      List<Map<String, dynamic>> categoryList = [];
      for (var category in categories) {
        String categoryName = category['name'];
        List<dynamic> subcategories = category['subcategories'];
        categoryList.add({
          'category_name': categoryName,
          'subcategories': subcategories,
        });
      }

      return categoryList;
    } catch (e) {
      print('Error reading categories: $e');
      return [];
    }
  }

  static Future<bool> addCategory(String categoryName, List<String> subcategories) async {
    try {
      final file = await _getLocalFile();
      String jsonData = await file.readAsString();
      final parsedJson = jsonDecode(jsonData);
      List<dynamic> categories = parsedJson['categories'];

      // Check if the category already exists
      if (categories.any((category) => category['name'] == categoryName)) {
        return false; // Category already exists
      }

      // Add the new category to the list of categories
      categories.add({
        'name': categoryName,
        'subcategories': subcategories,
      });

      // Convert the updated JSON data to string
      String updatedJsonData = jsonEncode(parsedJson);

      // Write updated JSON data to the local file
      await file.writeAsString(updatedJsonData);
      return true;
    } catch (e) {
      print('Error adding category: $e');
      return false;
    }
  }

  static Future<bool> updateCategory(String categoryName, List<String> subcategories) async {
    try {
      final file = await _getLocalFile();
      String jsonData = await file.readAsString();
      final parsedJson = jsonDecode(jsonData);
      List<dynamic> categories = parsedJson['categories'];

      // Find the category by name and update its subcategories
      for (var category in categories) {
        if (category['name'] == categoryName) {
          category['subcategories'] = subcategories;
          break;
        }
      }

      // Convert the updated JSON data to string
      String updatedJsonData = jsonEncode(parsedJson);

      // Write updated JSON data back to the local file
      await file.writeAsString(updatedJsonData);
      return true;
    } catch (e) {
      print('Error updating category: $e');
      return false;
    }
  }

  static Future<bool> deleteCategory(String categoryName) async {
    try {
      // Read JSON data from the local file
      final file = await _getLocalFile();
      String jsonData = await file.readAsString();
      final parsedJson = jsonDecode(jsonData);
      List<dynamic> categories = parsedJson['categories'];

      // Find the category by name and remove it from the list
      categories.removeWhere((category) => category['name'] == categoryName);

      // Convert the updated JSON data to string
      String updatedJsonData = jsonEncode(parsedJson);

      // Write updated JSON data back to the local file
      await file.writeAsString(updatedJsonData);
      return true;
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }

  static Future<List<String>> getSubcategoriesForCategory(String categoryName) async {
    try {
      // Read JSON data from the local file
      final file = await _getLocalFile();
      String jsonData = await file.readAsString();
      final parsedJson = jsonDecode(jsonData);
      List<dynamic> categories = parsedJson['categories'];

      // Find the category by name
      var category = categories.firstWhere((category) => category['name'] == categoryName, orElse: () => null);
      if (category != null) {
        // Return subcategories if category found
        return List<String>.from(category['subcategories']);
      } else {
        // Return an empty list if category not found
        return [];
      }
    } catch (e) {
      print('Error fetching subcategories: $e');
      return [];
    }
  }

  static Future<bool> addSubcategory(String categoryName, String newSubcategory) async {
    try {
      // Read JSON data from the asset
      String jsonData = await rootBundle.loadString('lib/assets/expense_categories.json');
      final parsedJson = jsonDecode(jsonData);
      List<dynamic> categories = parsedJson['categories'];

      // Find the category by name
      Map<String, dynamic>? category = categories.firstWhere((category) => category['name'] == categoryName, orElse: () => null);
      if (category != null) {
        // Check if the subcategory already exists
        List<dynamic> subcategories = category['subcategories'];
        if (subcategories.contains(newSubcategory)) {
          return false; // Subcategory already exists
        }

        // Add the new subcategory
        subcategories.add(newSubcategory);

        // Update the category with the modified subcategories list
        category['subcategories'] = subcategories;

        // Write updated JSON data back to the asset
        String updatedJsonData = jsonEncode(parsedJson);
        Directory directory = await getApplicationDocumentsDirectory();
        String path = "${directory.path}/expense_categories.json";
        File file = File(path);
        await file.writeAsString(updatedJsonData);
        return true;
      }
      return false; // Category not found
    } catch (e) {
      print('Error adding subcategory: $e');
      return false;
    }
  }

  static Future<bool> updateSubcategory(String categoryName, String subcategoryName, String editedSubcategoryName) async {
    try {
      final file = await _getLocalFile();
      String jsonData = await file.readAsString();
      final parsedJson = jsonDecode(jsonData);
      List<dynamic> categories = parsedJson['categories'];

      // Find the category by name
      Map<String, dynamic>? category = categories.firstWhere((category) => category['name'] == categoryName, orElse: () => null);
      if (category != null) {
        // Find the subcategory by name within the category
        List<dynamic> subcategories = category['subcategories'];
        int subcategoryIndex = subcategories.indexOf(subcategoryName);
        if (subcategoryIndex != -1) {
          // Update the subcategory name
          subcategories[subcategoryIndex] = editedSubcategoryName;

          // Write updated JSON data back to the local file
          await file.writeAsString(jsonEncode(parsedJson));
          return true;
        }
      }
      return false; // Category or subcategory not found
    } catch (e) {
      print('Error updating subcategory: $e');
      return false;
    }
  }

  static Future<bool> deleteSubcategory(String categoryName, String subcategoryName) async {
    try {
      final file = await _getLocalFile();
      String jsonData = await file.readAsString();
      final parsedJson = jsonDecode(jsonData);
      List<dynamic> categories = parsedJson['categories'];

      // Find the category by name
      Map<String, dynamic>? category = categories.firstWhere((category) => category['name'] == categoryName, orElse: () => null);
      if (category != null) {
        // Find the subcategory by name within the category
        List<dynamic> subcategories = category['subcategories'];
        if (subcategories.contains(subcategoryName)) {
          // Delete the subcategory
          subcategories.remove(subcategoryName);

          // Update the category with the modified subcategories list
          category['subcategories'] = subcategories;

          // Write updated JSON data back to the local file
          await file.writeAsString(jsonEncode(parsedJson));
          print('Subcategory $subcategoryName deleted successfully'); // Add this debug print
          return true;
        }
      }
      print('Subcategory $subcategoryName not found'); // Add this debug print
      return false; // Category or subcategory not found
    } catch (e) {
      print('Error deleting subcategory: $e');
      return false;
    }
  }
}
