import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_list_app/UI/purchased_history_ui.dart';
import '../Providers/state_notfier_provider.dart';
import '../classes/grocery_details_class.dart';

class GroceryScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final groceryAsyncValue = ref.watch(groceryListProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: Icon(
              filter == FilterType.all
                  ? Icons.filter_list_off
                  : filter == FilterType.purchased
                  ? Icons.check_box
                  : Icons.filter_list,
            ),
            tooltip: filter == FilterType.all
                ? 'Show Purchased'
                : filter == FilterType.purchased
                ? 'Show Unpurchased'
                : 'Show All',
            onPressed: () {
              ref.read(filterProvider.notifier).state =
              filter == FilterType.all
                  ? FilterType.purchased
                  : filter == FilterType.purchased
                  ? FilterType.unpurchased
                  : FilterType.all;
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Purchase History",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PurchasedHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: groceryAsyncValue.when(
        data: (fullList) {
          final filteredItems = ref.watch(filteredGroceryListProvider(fullList));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _buildInfoCard(
                      "Total",
                      fullList.where((item) => !item.purchased).length,
                    ),
                    const SizedBox(width: 10),
                    _buildInfoCard(
                      "Purchased",
                      fullList.where((item) => item.purchased).length,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredItems.isEmpty
                    ? const Center(child: Text("No items"))
                    : ListView.builder(
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(item.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _showEditDialog(item),
                            ),
                            Checkbox(
                              value: item.purchased,
                              onChanged: (_) {
                                togglePurchased(
                                    item.id, !item.purchased);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              onPressed: () {
                                deleteGroceryItem(item.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildAddItemField(),
            ],
          );
        },
        loading: () =>
        const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildInfoCard(String title, int count) {
    return Expanded(
      child: Card(
        elevation: 6,
        color: Colors.lightGreen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                title,
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                '$count',
                style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddItemField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add grocery item...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              final text = _controller.text.trim();
              if (text.isNotEmpty) {
                addGroceryItem(text);
                _controller.clear();
              }
            },
            child: const Text(
              'Add',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  void _showEditDialog(GroceryItem item) {
    final TextEditingController editController =
    TextEditingController(text: item.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Item'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Item name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editController.text.trim();
                if (newName.isNotEmpty) {
                  editGroceryItem(item.id, newName);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
