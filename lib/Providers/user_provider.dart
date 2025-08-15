import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list_app/classes/user_model.dart';
// Auth provider
//Will help me access the current user
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// User profile stream provider (READ)
final userProfileProvider = StreamProvider<UserProfile?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final user = auth.currentUser;
  if (user == null) return Stream.value(null);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) =>
  doc.exists ? UserProfile.fromMap(doc.id, doc.data()!) : null);
});

// CRUD Functions
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

class UserRepository {
  final _users = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserProfile profile) async {
    await _users.doc(profile.uid).set(profile.toMap());
  }

  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    await _users.doc(uid).update(updates);
  }

  Future<void> deleteUser(String uid) async {
    await _users.doc(uid).delete();
  }
}
