import 'package:flutter/material.dart';

void showModifyPostDialog({
  required BuildContext context,
  required String initialTitle,
  required String initialMessage,
  required Function(String, String) onEdit,
}) {
  TextEditingController titleController =
      TextEditingController(text: initialTitle);
  TextEditingController messageController =
      TextEditingController(text: initialMessage);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Modify Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Message'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              String newTitle = titleController.text.trim();
              String newMessage = messageController.text.trim();
              if (newTitle.isNotEmpty && newMessage.isNotEmpty) {
                onEdit(newTitle, newMessage);
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
