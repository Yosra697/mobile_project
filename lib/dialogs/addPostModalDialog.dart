import 'package:flutter/material.dart';

class AddPostModal extends StatefulWidget {
  final String categoryName;
  final Function(String title, String message, String categoryName) onAdd;

  AddPostModal({
    String? initialTitle,
    String? initialMessage,
    required this.categoryName,
    required this.onAdd,
  });

  @override
  _AddPostModalState createState() => _AddPostModalState();
}

class _AddPostModalState extends State<AddPostModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Post'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: _messageController,
            decoration: InputDecoration(labelText: 'Message'),
          ),
          TextFormField(
            initialValue: widget.categoryName,
            enabled: false,
            decoration: InputDecoration(labelText: 'Category'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String title = _titleController.text.trim();
            String message = _messageController.text.trim();
            String categoryName = widget.categoryName;
            if (title.isNotEmpty && message.isNotEmpty) {
              widget.onAdd(title, message, categoryName);
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
