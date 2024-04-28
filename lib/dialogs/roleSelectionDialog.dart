import 'package:flutter/material.dart';

class RoleSelectionDialog extends StatefulWidget {
  @override
  _RoleSelectionDialogState createState() => _RoleSelectionDialogState();
}

class _RoleSelectionDialogState extends State<RoleSelectionDialog> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose Your Role'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Teacher'),
            leading: Radio<String>(
              value: 'teacher',
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              activeColor: Colors.blue, // Set active color to blue
            ),
          ),
          ListTile(
            title: Text('User'),
            leading: Radio<String>(
              value: 'user',
              groupValue: _selectedRole,
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
              activeColor: Colors.blue, // Set active color to blue
            ),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedRole);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Colors.blue), // Set text color to blue
              ),
              child: Text('Next')),
        ],
      ),
    );
  }
}
