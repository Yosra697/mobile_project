import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/dialogs/addPostModalDialog.dart';
import 'package:mobile_project/dialogs/deletePostDialog.dart';
import 'package:mobile_project/dialogs/modifyPostDialog.dart';
import 'package:mobile_project/entity/post.dart';
import 'package:mobile_project/screens/login_page.dart';
import 'package:mobile_project/services/postService.dart';

class CategoryDetailPage extends StatefulWidget {
  final String category;

  CategoryDetailPage({required this.category});

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  final PostService _postService = PostService();
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    _postService.getPostsByCategory(widget.category).listen((snapshot) {
      setState(() {
        _posts = snapshot.docs
            .map((doc) => Post(
                  title: doc['title'],
                  message: doc['message'],
                  categoryName: doc['categoryName'],
                ))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category,
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
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          Post post = _posts[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                title: Text(post.title),
                subtitle: Text(post.message),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      showDeleteConfirmationPostDialog(
                          context, post.title, _postService);
                      _loadPosts();
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                  IconButton(
                    onPressed: () {
                      showModifyPostDialog(
                        context: context,
                        initialTitle: post.title,
                        initialMessage: post.message,
                        onEdit: (String newTitle, String newMessage) {
                          // Call the postService to update the post
                          _postService.updatePost(post.title, {
                            'title': newTitle,
                            'message': newMessage,
                          });
                          // Reload posts after updating
                          _loadPosts();
                        },
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.blue),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPostModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddPostModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddPostModal(
        categoryName: widget.category,
        onAdd: (String title, String message, String categoryName) async {
          await _postService.addPost(title, message, categoryName);
          // Refresh the posts list after adding a new post
          _loadPosts();
        },
      ),
    );
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
