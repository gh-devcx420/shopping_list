import 'package:flutter/material.dart';
import 'package:shopping_list/data/grocery_list.dart';
import 'package:shopping_list/screens/add_item_screen.dart';

class ShoppingListHomeScreen extends StatefulWidget {
  const ShoppingListHomeScreen({super.key});

  @override
  State<ShoppingListHomeScreen> createState() => _ShoppingListHomeScreenState();
}

class _ShoppingListHomeScreenState extends State<ShoppingListHomeScreen> {
  void _addItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const AddItemScreen();
        },
      ),
    );
    if (newItem != null) {
      setState(() {
        groceryItems.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body = const Center(
      child: Text('No Data'),
    );
    if (groceryItems.isNotEmpty) {
      body = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(groceryItems[index].id),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) async {
              return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this item?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  });
            },
            onDismissed: (direction) {
              setState(() {
                groceryItems.remove(groceryItems[index]);
              });
            },
            child: ListTile(
              leading: Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  color: groceryItems[index].category.categoryColour,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              title: Text(
                groceryItems[index].itemName,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: Text(
                groceryItems[index].quantity.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addItem(context);
        },
        backgroundColor: Colors.teal,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: body,
    );
  }
}
