import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_project/common/toast.dart';

class CategoryService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // Create operation
  Future<void> addCategory(String categoryName) async {
    try {
      await _firebaseFirestore.collection('category').doc(categoryName).set({
        'name': categoryName,
      });
    } catch (e) {
      print("Error adding category to Firestore: $e");
      showToast(message: "Error: $e");
    }
  }

  // Read operation

  Future<Map<String, dynamic>?> getCategory(String? categoryName) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(categoryName)
          .get();

      if (snapshot != null && snapshot.exists) {
        Map<String, dynamic>? categoryData =
            snapshot.data() as Map<String, dynamic>?;
        return categoryData;
      } else {
        print('Document not found.');
      }
      return null;
    } catch (e) {
      print("Error getting category from Firestore: $e");
      showToast(message: "Error: $e");
      return null;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      QuerySnapshot querySnapshot =
          await _firebaseFirestore.collection('category').get();

      List<String> categories = [];
      querySnapshot.docs.forEach((doc) {
        // Access the data within each document and retrieve the 'name' field
        // You can replace 'name' with the actual field name where your category name is stored
        var categoryName = (doc.data() as Map<String, dynamic>?)?['name'];
        if (categoryName != null) {
          categories.add(categoryName);
        }
      });
      return categories;
    } catch (e) {
      print("Error getting categories from Firestore: $e");
      showToast(message: "Error: $e");
      return [];
    }
  }

  // Update operation
  Future<void> updateCategory(
      String categoryName, Map<String, dynamic> newData) async {
    try {
      await _firebaseFirestore
          .collection('category')
          .doc(categoryName)
          .update(newData);
    } catch (e) {
      print("Error updating category in Firestore: $e");
      showToast(message: "Error: $e");
    }
  }

  // Delete operation
  Future<void> deleteCategory(String categoryName) async {
    try {
      await _firebaseFirestore
          .collection('category')
          .doc(categoryName)
          .delete();
    } catch (e) {
      print("Error deleting category from Firestore: $e");
      showToast(message: "Error: $e");
    }
  }

  Future<void> addCategoryToUser(String email, String category) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      // Get reference to the user's document in Firestore
      DocumentReference userRef =
          firebaseFirestore.collection('users').doc(email);

      // Update the user's document to add the category
      await userRef.update({
        'categories': FieldValue.arrayUnion([category]),
      });
    } catch (e) {
      print("Error adding category to user: $e");
      showToast(message: "Error: $e");
    }
  }

  Future<void> removeCategoryFromUser(String email, String category) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      // Get reference to the user's document in Firestore
      DocumentReference userRef =
          firebaseFirestore.collection('users').doc(email);

      // Update the user's document to remove the category
      await userRef.update({
        'categories': FieldValue.arrayRemove([category]),
      });
    } catch (e) {
      print("Error removing category from user: $e");
      showToast(message: "Error: $e");
    }
  }

  Future<bool> isUserFollowingCategory(String email, String category) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      // Get reference to the user's document in Firestore
      DocumentSnapshot userSnapshot =
          await firebaseFirestore.collection('users').doc(email).get();

      // Check if the user's document exists
      if (userSnapshot.exists) {
        // Cast userData to Map<String, dynamic>
        Map<String, dynamic>? userData =
            userSnapshot.data() as Map<String, dynamic>?;

        // Check if userData is not null and contains the 'categories' key
        if (userData != null && userData.containsKey('categories')) {
          // Get the categories list from userData
          List<dynamic>? categories = userData['categories'];

          // Check if categories is not null and contains the specified category
          if (categories != null && categories.contains(category)) {
            return true;
          }
        }
      }
      return false;
    } catch (e) {
      print("Error checking if user is following category: $e");
      showToast(message: "Error: $e");
      return false;
    }
  }

  Future<List<String>?> getUserCategories(String email) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firebaseFirestore.collection('users').doc(email).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        if (userData.containsKey('categories')) {
          List<String> categories = List<String>.from(userData['categories']);
          return categories;
        }
      }
      return [];
    } catch (e) {
      print("Error getting user categories: $e");
      return null;
    }
  }
}
