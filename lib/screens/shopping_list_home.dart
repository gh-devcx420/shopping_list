import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/data/grocery_list.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/add_item_screen.dart';
import 'package:shopping_list/theme/color_scheme.dart';

class ShoppingListHomeScreen extends StatefulWidget {
  const ShoppingListHomeScreen({super.key, required this.onThemeChanged});

  final void Function(AppColors) onThemeChanged;

  @override
  State<ShoppingListHomeScreen> createState() => _ShoppingListHomeScreenState();
}

class _ShoppingListHomeScreenState extends State<ShoppingListHomeScreen> {
  bool _isLoading = true;
  bool _showFAB = false;

  void loadItems() async {
    final url = Uri.https(
      'shopping-list-d65c7-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    final response = await http.get(url);
    try {
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
          _showFAB = true;
        });
        return;
      }
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
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _showFAB = true;
      });
    }
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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent = const Center(
      child: Text(
        'Shopping list is empty.',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
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
            background: Container(
              color: Colors.red,
              child: const Center(
                child: Text(
                  'Deleting',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
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
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );
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
        leading: const Icon(
          Icons.shopping_cart,
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Choose Theme'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...lightColorSchemes.entries.map((themeItem) {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  widget.onThemeChanged(themeItem.key);
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 25,
                                      width: 25,
                                      decoration: BoxDecoration(
                                        color: themeItem.value.previewColor,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      themeItem.value.themeName,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    );
                  });
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      floatingActionButton: _showFAB
          ? FloatingActionButton(
              onPressed: () {
                _addItem(context);
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : Container(),
      body: bodyContent,
    );
  }
}
