import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
final authServiceProvider = Provider<AuthService>((ref) => AuthService());
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign Up Error: $e");
      return null;
    }
  }

  // Sign in
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print("Reset Password Error: $e");
      rethrow;
    }
  }
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
