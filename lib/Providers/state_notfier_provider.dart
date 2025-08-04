import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_list_app/classes/grocery_details_class.dart';
class GroceryListNotifier extends StateNotifier<List<GroceryItem>> {
  GroceryListNotifier() : super([]);

  void add(String name) {
    final item = GroceryItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
    );
    state = [...state, item];
  }

  void togglePurchased(String id) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(purchased: !item.purchased)
        else
          item
    ];
  }

  void editItem(String id, String newName) {
    state = [
      for (final item in state)
        if (item.id == id)
          item.copyWith(name: newName)
        else
          item
    ];
  }

  void delete(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

final groceryListProvider =
StateNotifierProvider<GroceryListNotifier, List<GroceryItem>>(
        (ref) => GroceryListNotifier());

enum FilterType { all, purchased }

final filterProvider = StateProvider<FilterType>((ref) => FilterType.all);

final filteredGroceryListProvider = Provider<List<GroceryItem>>((ref) {
  final filter = ref.watch(filterProvider);
  final items = ref.watch(groceryListProvider);

  return switch (filter) {
    FilterType.purchased =>
        items.where((item) => item.purchased).toList(),
    FilterType.all =>
        items.where((item) => !item.purchased).toList(),
  };
});
