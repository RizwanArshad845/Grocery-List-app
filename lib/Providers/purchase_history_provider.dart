import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_list_app/Providers/state_notfier_provider.dart';
import 'package:grocery_list_app/classes/grocery_details_class.dart';

enum HistoryFilter { all, last7Days, lastMonth }

// Controls which filter is selected
final historyFilterProvider =
StateProvider<HistoryFilter>((ref) => HistoryFilter.all);

// Async provider that fetches all purchased items from the DB
final purchasedHistoryProvider = FutureProvider<List<GroceryItem>>((ref) async {
  final groceries = await ref.watch(groceryListProvider.future); // get data from DB
  return groceries.where((item) => item.purchased).toList();
});

// Applies the filter to the purchased items
final filteredHistoryProvider =
Provider<AsyncValue<List<GroceryItem>>>((ref) {
  final filter = ref.watch(historyFilterProvider);
  final purchasedAsync = ref.watch(purchasedHistoryProvider);

  return purchasedAsync.whenData((purchasedItems) {
    final now = DateTime.now();

    switch (filter) {
      case HistoryFilter.last7Days:
        return purchasedItems
            .where((item) =>
        item.purchasedDate != null &&
            now.difference(item.purchasedDate!).inDays > 0 && // exclude today
            now.difference(item.purchasedDate!).inDays < 7)
            .toList();
      case HistoryFilter.lastMonth:
        return purchasedItems
            .where((item) =>
        item.purchasedDate != null &&
            now.difference(item.purchasedDate!).inDays >7 &&  now.difference(item.purchasedDate!).inDays <= 30)
            .toList();
      case HistoryFilter.all:
      default:
        return purchasedItems;
    }
  });
});

