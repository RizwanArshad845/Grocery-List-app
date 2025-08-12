import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_list_app/Providers/purchase_history_provider.dart';

class PurchasedHistoryScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(historyFilterProvider);
    final itemsAsync = ref.watch(filteredHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Purchased History"),
        backgroundColor: Colors.lightGreen,
        actions: [
          DropdownButton<HistoryFilter>(
            value: filter,
            onChanged: (value) {
              if (value != null) {
                ref.read(historyFilterProvider.notifier).state = value;
              }
            },
            items: HistoryFilter.values.map((f) {
              return DropdownMenuItem(
                value: f,
                child: Text(f == HistoryFilter.all
                    ? "All"
                    : f == HistoryFilter.last7Days
                    ? "Last 7 Days"
                    : "Last Month"),
              );
            }).toList(),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) => items.isEmpty
            ? Center(child: Text("No purchased items"))
            : ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Card(
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(
                    "Purchased: ${item.purchasedDate != null
                        ? item.purchasedDate!.toLocal().toString().split(' ')[0]
                        : ''}"
                ),
              ),
            );
          },
        ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}

