import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String title;
  final String message;
  final String categoryName;

  Post({
    required this.title,
    required this.message,
    required this.categoryName,
  });

  // Convert Post object to a Map (serialization)
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'categoryName': categoryName,
    };
  }

  // Create a Post object from a Map (deserialization)
  static Post fromMap(Map<String, dynamic> map) {
    return Post(
      title: map['title'],
      message: map['message'],
      categoryName: map['categoryName'],
    );
  }

  // Convert Post object to a Firestore Document
  DocumentReference toDocument() {
    return FirebaseFirestore.instance.collection('posts').doc(title);
  }
}
