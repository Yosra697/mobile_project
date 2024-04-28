import 'package:flutter/material.dart';
import 'package:mobile_project/services/postService.dart';

void showDeleteConfirmationPostDialog(
    BuildContext context, String title, PostService postService) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Post?'),
        content: Text('Are you sure you want to delete this post?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await postService.deletePost(title);
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
