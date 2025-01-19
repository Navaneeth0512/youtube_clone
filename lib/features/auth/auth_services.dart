import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up with Email
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user; // Return the created user object
    } catch (e) {
      throw _handleAuthError(e); // Handle errors appropriately
    }
  }

  // Login with Email
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveLoginState(true); // Save login state locally
      return userCredential.user; // Return the authenticated user object
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut(); // Sign out the user from Firebase
    await _saveLoginState(false); // Update the login state locally
  }

  // Check Login State
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Check if login state exists
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email); // Send reset email
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Automatic Login Check on App Start
  Future<User?> checkIfLoggedIn() async {
    try {
      // Check if the user is already logged in via Firebase Auth.
      User? user = _auth.currentUser;

      if (user != null) {
        // If logged in, update SharedPreferences
        await _saveLoginState(true);
      }

      return user;
    } catch (e) {
      print('Error checking login status: $e');
      return null;
    }
  }

  // Save Login State
  Future<void> _saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn); // Save login state to SharedPreferences
  }

  // Error Handling
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return "The email address is already in use.";
        case 'invalid-email':
          return "The email address is not valid.";
        case 'operation-not-allowed':
          return "Email sign-in is not enabled. Please enable it in Firebase Console.";
        case 'user-disabled':
          return "This user has been disabled.";
        case 'wrong-password':
          return "The password is incorrect.";
        case 'user-not-found':
          return "No user found with this email.";
        default:
          return "FirebaseAuthException: ${error.message}";
      }
    }
    return "Unexpected error: $error";
  }
}
