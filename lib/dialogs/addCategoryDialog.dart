import 'package:flutter/material.dart';
import 'package:mobile_project/services/categoryService.dart';

class AddCategoryModal extends StatelessWidget {
  final CategoryService categoryService;
  final TextEditingController _categoryNameController = TextEditingController();

  AddCategoryModal({required this.categoryService});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Category',
        style: TextStyle(color: Colors.blue), // Set title color to blue
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            String categoryName = _categoryNameController.text.trim();
            if (categoryName.isNotEmpty) {
              categoryService.addCategory(categoryName);
              Navigator.pop(context); // Close the dialog
            }
          },
          child: Text(
            'Add',
            style:
                TextStyle(color: Colors.blue), // Set button text color to blue
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text(
            'Cancel',
            style:
                TextStyle(color: Colors.blue), // Set button text color to blue
          ),
        ),
      ],
    );
  }
}
