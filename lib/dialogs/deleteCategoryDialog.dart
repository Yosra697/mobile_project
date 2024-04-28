import 'package:flutter/material.dart';
import 'package:mobile_project/services/categoryService.dart';

void showDeleteConfirmationDialog(
    BuildContext context, String category, CategoryService categoryService) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Category?'),
        content: Text('Are you sure you want to delete this category?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await categoryService.deleteCategory(category);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
