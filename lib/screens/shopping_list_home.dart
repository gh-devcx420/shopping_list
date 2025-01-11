import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/grocery_list.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/add_item_screen.dart';

class ShoppingListHomeScreen extends StatefulWidget {
  const ShoppingListHomeScreen({super.key});

  @override
  State<ShoppingListHomeScreen> createState() => _ShoppingListHomeScreenState();
}

class _ShoppingListHomeScreenState extends State<ShoppingListHomeScreen> {
  bool _isLoading = true;

  void loadItems() async {
    final url = Uri.https(
      'shopping-list-d65c7-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);

    List<GroceryItem> loadedList = [];
    for (final item in listData.entries) {
      final category = shoppingCategories.entries.firstWhere((categoryItem) {
        return categoryItem.value.title == item.value['category'];
      }).value;
      loadedList.add(
        GroceryItem(
          id: item.key,
          itemName: item.value['itemName'],
          category: category,
          quantity: item.value['quantity'],
        ),
      );
    }
    setState(() {
      groceryItems = loadedList;
      _isLoading = false;
    });
  }

  void _addItem(BuildContext context) async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const AddItemScreen();
        },
      ),
    );
    setState(() {
      groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    final url = Uri.https(
      'shopping-list-d65c7-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );
    http.delete(url);
    groceryItems.remove(item);
  }

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = const Center(
      child: Text('No Data'),
    );
    if (_isLoading) {
      bodyContent = const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (groceryItems.isNotEmpty) {
      bodyContent = ListView.builder(
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
                        'Are you sure you want to delete this item?',
                      ),
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
              _removeItem(
                groceryItems[index],
              );
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
      body: bodyContent,
    );
  }
}
