import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mobile_project/common/pushNotification.dart';
import 'package:mobile_project/screens/student.dart';
import 'package:mobile_project/screens/teacher.dart';
import 'package:mobile_project/screens/followcategoryPage.dart';
import 'package:mobile_project/screens/login_page.dart';
import 'package:mobile_project/screens/sign_up_page.dart';
import 'package:mobile_project/splash_screen/splash_screen.dart';

// function to lisen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received");
  }
}

bool isStudentConnected = false;
final navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String apiKey = "AIzaSyCOosAlDomKkIx-VRdYpDr6IibJMQZl7pI";
  String appId = "1:701068110883:android:ebae5e05dc9e5a53fb9596";
  String messagingSenderId = "701068110883";
  String projectId = "mobileproject-6b076";

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
    ),
  );
  // Initialize push notifications
  await PushNotifications.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase - by Yosra SASSI',
      routes: {
        '/': (context) => SplashScreen(
              child: LoginPage(),
            ),
        '/login': (context) {
          isStudentConnected = false;
          return LoginPage();
        },
        '/signUp': (context) => SignUpPage(),
        '/student': (context) {
          isStudentConnected = true;
          return Student(
            email: ModalRoute.of(context)!.settings.arguments as String,
          );
        },
        '/teacher': (context) {
          isStudentConnected = false;
          return Teacher();
        },
        '/followCategoriesPage': (context) {
          isStudentConnected = true;
          return FollowCategoryPage(
            email: ModalRoute.of(context)!.settings.arguments as String,
          );
        },
      },
    );
  }
}
