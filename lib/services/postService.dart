import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_project/common/toast.dart';
import 'package:mobile_project/entity/post.dart';
import 'package:mobile_project/services/categoryService.dart';

class PostService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Create operation
  Future<void> addPost(
      String title, String message, String categoryName) async {
    try {
      await _firebaseFirestore.collection('posts').doc(title).set({
        'title': title,
        'message': message,
        'categoryName': categoryName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding post to Firestore: $e");
      showToast(message: "Error: $e");
    }
  }

  // Read operation
  Stream<QuerySnapshot> getPostsByCategory(String categoryName) {
    try {
      return _firebaseFirestore
          .collection('posts')
          .where('categoryName', isEqualTo: categoryName)
          .snapshots();
    } catch (e) {
      print("Error getting posts by category from Firestore: $e");
      showToast(message: "Error: $e");
      // Return an empty stream in case of error
      return Stream.empty();
    }
  }

  // Update operation
  Future<void> updatePost(String postId, Map<String, dynamic> newData) async {
    try {
      await _firebaseFirestore.collection('posts').doc(postId).update(newData);
    } catch (e) {
      print("Error updating post in Firestore: $e");
      showToast(message: "Error: $e");
    }
  }

  // Delete operation
  Future<void> deletePost(String title) async {
    try {
      await _firebaseFirestore.collection('posts').doc(title).delete();
    } catch (e) {
      print("Error deleting post from Firestore: $e");
      showToast(message: "Error: $e");
    }
  }

  Future<List<Post>> getPostsByUser(String userEmail) async {
    try {
      final CategoryService _categoryService = CategoryService();
      // Retrieve user categories
      List<String>? userCategories =
          await _categoryService.getUserCategories(userEmail);

      // Fetch all posts
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      // Map query results to Post objects and filter based on user categories
      List<Post> posts = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Post.fromMap(data);
      }).toList();

      // Filter posts based on user categories
      List<Post> filteredPosts = posts
          .where((post) => userCategories!.contains(post.categoryName))
          .toList();

      return filteredPosts;
    } catch (e) {
      print("Error getting posts by user from Firestore: $e");
      showToast(message: "Error: $e");
      return [];
    }
  }
}
