import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_project/common/toast.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String? rool) async {
    try {
      // Create user using FirebaseAuth
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the Firebase user object
      User? user = credential.user;

      // If the user is not null, save additional details to Firestore
      if (user != null) {
        await postDetailsToFirestore(email, rool);
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    } catch (e) {
      print("Error signing up: $e");
      showToast(message: 'An error occurred: $e');
    }

    return null;
  }

  Future<void> postDetailsToFirestore(String email, String? rool) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      CollectionReference ref = firebaseFirestore.collection('users');

      await ref.doc(email).set({
        'email': email,
        'rool': rool,
      });
    } catch (e) {
      print("Error posting details to Firestore: $e");
      showToast(message: "Error: $e");
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.');
      } else {
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
    return null;
  }

  Future<String?> getUserRoleFromFirestore(String? email) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (snapshot != null && snapshot.exists) {
        Map<String, dynamic>? userData =
            snapshot.data() as Map<String, dynamic>?;
        if (userData != null && userData.containsKey('rool')) {
          // If 'rool' value exists in userData, return it
          return userData['rool'];
        }
      } else {
        print('Document not found.');
      }
      return null;
    } catch (e) {
      // Handle any errors that occur during the fetching process
      showToast(message: 'Failed to fetch user role: $e');
      return null;
    }
  }
}
