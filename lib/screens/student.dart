import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/common/pushNotification.dart';
import 'package:mobile_project/entity/post.dart';
import 'package:mobile_project/main.dart';
import 'package:mobile_project/screens/followcategoryPage.dart';
import 'package:mobile_project/screens/login_page.dart';
import 'package:mobile_project/services/postService.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Student extends StatefulWidget {
  final String email; // Add email as a parameter
  const Student({Key? key, required this.email}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  final PostService _postService = PostService(); // Change to PostService
  late List<Post> _posts = []; // Change to hold Post objects
  late String _email = ''; // Declare a variable to hold the email

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _loadPosts();
    _configureFirebase();
  }

  void _configureFirebase() {
    PushNotifications.init();
    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);
    _handleBackgroundNotificationTapped();
    _handleForegroundNotifications();
  }

  void _handleBackgroundNotificationTapped() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("Background Notification Tapped");
        navigatorKey.currentState!.pushNamed("/student", arguments: message);
      }
    });
  }

  void _handleForegroundNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String payloadData = jsonEncode(message.data);
      print("Got a message in foreground");
      if (message.notification != null) {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    });
  }

  // Firebase background message handler
  Future<void> _firebaseBackgroundMessage(RemoteMessage message) async {
    print("Message from push notification is ${message.data}");
    String payloadData = jsonEncode(message.data);
    PushNotifications.showSimpleNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
        payload: payloadData);
  }

  Future<void> _loadPosts() async {
    // Change method name
    List<Post>? posts =
        await _postService.getPostsByUser(_email); // Pass _email
    setState(() {
      _posts = posts ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student",
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
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FollowCategoryPage(email: _email),
                    ),
                  );
                },
                child: Text(
                  'Follow new categories',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildPostsList(), // Add parentheses to call the method
          ),
        ],
      ),
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

  Widget _buildPostsList() {
    if (_posts.isEmpty) {
      return Container();
    } else {
      return ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          Post post = _posts[index]; // Change to use Post object
          return GestureDetector(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                title: Text(post.title),
                subtitle: Text(post.message), // Change to subtitle
                onTap: () {
                  // Handle onTap if needed
                },
              ),
            ),
          );
        },
      );
    }
  }
}
