import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/services/categoryService.dart';
import 'package:mobile_project/screens/login_page.dart';

class FollowCategoryPage extends StatefulWidget {
  final String email;

  const FollowCategoryPage({Key? key, required this.email}) : super(key: key);

  @override
  _FollowCategoryPageState createState() => _FollowCategoryPageState();
}

class _FollowCategoryPageState extends State<FollowCategoryPage> {
  final CategoryService _categoryService = CategoryService();
  late List<String> _categories = [];
  late String _email = ''; // Declare a variable to hold the email

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _loadCategories();
  }

  String replaceSpacesWithUnderscores(String input) {
    return input.replaceAll(' ', '_');
  }

  Future<void> _loadCategories() async {
    List<String>? categories = await _categoryService.getCategories();
    setState(() {
      _categories = categories ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use _email variable wherever you need to access the email in this class
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Follow Category",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/student', arguments: _email);
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
    );
  }

  Future<void> logout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Widget _buildCategoriesList() {
    // Use _email variable wherever you need to access the email in this method
    if (_categories.isEmpty) {
      return Container();
    } else {
      return ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          String category = _categories[index];
          return GestureDetector(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                title: Text(category),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<bool>(
                      future: _categoryService.isUserFollowingCategory(_email,
                          category), // Use _email instead of widget.email
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          bool isFollowing = snapshot.data ?? false;
                          return TextButton(
                            onPressed: () async {
                              if (isFollowing) {
                                await FirebaseMessaging.instance
                                    .unsubscribeFromTopic(
                                        replaceSpacesWithUnderscores(category));
                                await _categoryService.removeCategoryFromUser(
                                    _email, category);
                              } else {
                                await FirebaseMessaging.instance
                                    .subscribeToTopic(
                                        replaceSpacesWithUnderscores(category))
                                    .then((value) {
                                  print(replaceSpacesWithUnderscores(category));
                                });

                                await _categoryService.addCategoryToUser(
                                    _email, category);
                              }
                              setState(() {});
                            },
                            child: Text(
                              isFollowing ? 'Unfollow' : 'Follow',
                              style: TextStyle(
                                color: isFollowing ? Colors.red : Colors.blue,
                              ),
                            ),
                          );
                        }
                      },
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
}
