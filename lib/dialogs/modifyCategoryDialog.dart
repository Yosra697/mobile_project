import 'package:flutter/material.dart';
import 'package:mobile_project/services/categoryService.dart';

void showModifyCategoryDialog(
    BuildContext context, String category, CategoryService categoryService) {
  TextEditingController controller = TextEditingController(text: category);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modify Category'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'New Category Name'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              String newCategoryName = controller.text.trim();
              if (newCategoryName.isNotEmpty) {
                await categoryService
                    .updateCategory(category, {'name': newCategoryName});
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}
