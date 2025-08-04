import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_list_app/Providers/state_notfier_provider.dart';
import 'package:grocery_list_app/classes/grocery_details_class.dart';
class GroceryScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filteredItems = ref.watch(filteredGroceryListProvider);
    final fullList = ref.watch(groceryListProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Grocery List'),
        centerTitle: true,
        backgroundColor: Colors.lightGreen,
        actions: [
          IconButton(
            icon: Icon(
              filter == FilterType.all ? Icons.filter_list_off : Icons.filter_list,
            ),
            tooltip: filter == FilterType.all
                ? 'Show Purchased'
                : 'Show Unpurchased',
            onPressed: () {
              ref.read(filterProvider.notifier).state =
              filter == FilterType.all ? FilterType.purchased : FilterType.all;
            },
          )
        ],
      ),
      body:  Column(
          children: [
            Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  _buildInfoCard("Total", fullList.length),
                  SizedBox(width: 10),
                  _buildInfoCard(
                      "Purchased",
                      fullList.where((item) => item.purchased).length),
                ],
              ),
            ),
            Expanded(
              child: filteredItems.isEmpty
                  ? Center(child: Text("No items"))
                  : ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: ListTile(
                      title: Text(item.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, size: 20),
                            onPressed: () => _showEditDialog(item),
                          ),
                          Checkbox(
                            value: item.purchased,
                            onChanged: (_) {
                              ref.read(groceryListProvider.notifier)
                                  .togglePurchased(item.id);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, size: 20),
                            onPressed: () {
                              ref.read(groceryListProvider.notifier)
                                  .delete(item.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Add grocery item...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final text = _controller.text.trim();
                      if (text.isNotEmpty) {
                        ref.read(groceryListProvider.notifier).add(text);
                        _controller.clear();
                      }
                    },
                    child: Text('Add',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),),
                  )
                ],
              ),
            )
          ],
        ),
      );

  }

  Widget _buildInfoCard(String title, int count) {
    return Expanded(
      child: Card(
        elevation:6 ,
        color:Colors.lightGreen,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              SizedBox(height: 4),
              Text('$count',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              )),
            ],
          ),
        ),
        )
      );
  }

  void _showEditDialog(GroceryItem item) {
    final TextEditingController editController =
    TextEditingController(text: item.name);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Item'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(labelText: 'Item name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newName = editController.text.trim();
                if (newName.isNotEmpty) {
                  ref.read(groceryListProvider.notifier)
                      .editItem(item.id, newName);
                }
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
