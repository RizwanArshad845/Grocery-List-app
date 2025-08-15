import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grocery_list_app/Providers/state_notfier_provider.dart';
import 'package:riverpod/riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref: ref));

class AuthService {
  AuthService({required this.ref});
  final Ref ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _createUserProfile(user);
      }

      return user;
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
      User? user = result.user;

      if (user != null) {
        await _createUserProfile(user);
      }

      return user;
    } catch (e) {
      print("Sign In Error: $e");
      return null;
    }
  }

  // Create user profile in Firestore if it doesn't exist
  Future<void> _createUserProfile(User user) async {
    DocumentReference userDoc = _firestore.collection('users').doc(user.uid);

    DocumentSnapshot docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("User profile created for ${user.email}");
    } else {
      print("User profile already exists for ${user.email}");
    }
  }

  // Reset password
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
    await _auth.signOut().then((_){ref.invalidate(groceryListProvider);});

  }
}
