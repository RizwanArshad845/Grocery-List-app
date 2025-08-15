import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grocery_list_app/Providers/user_provider.dart';
import 'package:grocery_list_app/classes/user_model.dart';
import '../classes/grocery_details_class.dart';
final groceryListProvider = StreamProvider<List<GroceryItem>>((ref) {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  if (user == null) {
    // No one logged in → return empty list
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('users')              // All users
      .doc(user.uid)                    // The logged-in user's doc
      .collection('groceries')          // That user's groceries subcollection
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => GroceryItem.fromMap(doc.id, doc.data()))
      .toList());
});

enum FilterType { all, purchased, unpurchased }

final filterProvider = StateProvider<FilterType>((ref) => FilterType.all);

final filteredGroceryListProvider =
Provider.family<List<GroceryItem>, List<GroceryItem>>((ref, items) {
  final filter = ref.watch(filterProvider);
  switch (filter) {
    case FilterType.purchased:
      return items.where((item) => item.purchased).toList();
    case FilterType.unpurchased:
      return items.where((item) => !item.purchased).toList();
    case FilterType.all:
    default:
      return items;
  }
});
Future<void> addGrocery(GroceryItem item, UserProfile profile) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(profile.uid)
      .collection('groceries')
      .add(item.toMap());
}

Future<void> togglePurchased(String id, bool purchased, UserProfile profile) async {
  await FirebaseFirestore.instance
      .collection('users')           // go to users collection
      .doc(profile.uid)              // go to current user's document
      .collection('groceries')       // go to user's groceries subcollection
      .doc(id)                       // specific grocery item
      .update({
    'purchased': purchased,
    'purchasedDate': purchased ? DateTime.now().toIso8601String() : null,
  });
}
Future<void> deleteGrocery(String groceryId, UserProfile profile) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(profile.uid)
      .collection('groceries')
      .doc(groceryId)
      .delete();
}

Future<void> updateGrocery(String groceryId, Map<String, dynamic> updates, UserProfile profile) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(profile.uid)
      .collection('groceries')
      .doc(groceryId)
      .update(updates);
}