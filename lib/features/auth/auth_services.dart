import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign Up with Email
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Login with Email
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _saveLoginState(true);
      return userCredential.user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _saveLoginState(false);
  }

  // Check Login State
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Save Login State
  Future<void> _saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', isLoggedIn);
  }

  // Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Error Handling
  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return "The email address is already in use.";
        case 'wrong-password':
          return "Incorrect password.";
        case 'user-not-found':
          return "No user found with this email.";
        case 'weak-password':
          return "The password is too weak.";
        default:
          return "An unexpected error occurred.";
      }
    }
    return "An error occurred. Please try again.";
  }
}
