import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../classes/grocery_details_class.dart';

final groceryListProvider = StreamProvider<List<GroceryItem>>((ref) {
  return FirebaseFirestore.instance
      .collection('groceries')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => GroceryItem.fromMap(doc.id, doc.data())).toList());
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

/// Firestore operations
Future<void> addGroceryItem(String name) async {
  await FirebaseFirestore.instance.collection('groceries').add({
    'name': name,
    'purchased': false,
    'purchasedDate': null,
  });
}

Future<void> togglePurchased(String id, bool purchased) async {
  await FirebaseFirestore.instance.collection('groceries').doc(id).update({
    'purchased': purchased,
    'purchasedDate': purchased ? DateTime.now().toIso8601String() : null,
  });
}

Future<void> deleteGroceryItem(String id) async {
  await FirebaseFirestore.instance.collection('groceries').doc(id).delete();
}

Future<void> editGroceryItem(String id, String newName) async {
  await FirebaseFirestore.instance.collection('groceries').doc(id).update({
    'name': newName,
  });
}
