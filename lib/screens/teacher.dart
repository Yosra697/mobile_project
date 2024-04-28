import 'package:flutter/material.dart';
import 'package:mobile_project/dialogs/addCategoryDialog.dart';
import 'package:mobile_project/dialogs/deleteCategoryDialog.dart';
import 'package:mobile_project/dialogs/modifyCategoryDialog.dart';
import 'package:mobile_project/services/categoryService.dart';
import 'package:mobile_project/screens/categoryDetailPage.dart';
import 'package:mobile_project/screens/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  final CategoryService _categoryService = CategoryService();

  late List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<String>? categories = await _categoryService.getCategories();
    setState(() {
      _categories = categories ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Teacher",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: _buildCategoriesList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) =>
                AddCategoryModal(categoryService: _categoryService),
          ).then((_) =>
              _loadCategories()); // Reload categories after adding a new one
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _buildCategoriesList() {
    if (_categories.isEmpty) {
      return Container();
    } else {
      return ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          String category = _categories[index];
          return GestureDetector(
            onTap: () {
              // Navigate to the CategoryDetailPage with the selected category
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryDetailPage(category: category),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                title: Text(category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showDeleteConfirmationDialog(
                            context, category, _categoryService);
                        _loadCategories();
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                    IconButton(
                      onPressed: () {
                        showModifyCategoryDialog(
                            context, category, _categoryService);
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
