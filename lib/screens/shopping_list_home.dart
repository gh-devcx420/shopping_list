import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  bool _showFAB = false;
  bool _isLoading = true;
  bool _isLoadingError = false;

  Future<bool> isConnectedToInternet() async {
    final connectionStatus =
        await InternetConnectionChecker.instance.hasConnection;
    return connectionStatus;
  }

  void reloadData() async {
    setState(() {
      _isLoading = true;
    });
    if (await isConnectedToInternet()) {
      setState(() {
        loadItems();
        _isLoadingError = false;
      });
      if (!mounted) return;
      Fluttertoast.showToast(
        msg: 'Reloading...',
        backgroundColor: Theme.of(context).colorScheme.secondaryFixedDim,
        textColor: Theme.of(context).colorScheme.primary,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } else {
      setState(() {
        _isLoadingError = true;
      });
    }
  }

  void loadItems() async {
    final url = Uri.https(
      'shopping-list-d65c7-default-rtdb.firebaseio.com',
      'shopping-list.json',
    );
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        setState(() {
          _showFAB = true;
          _isLoading = false;
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
        _showFAB = true;
        _isLoading = false;
        groceryItems = loadedList;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _isLoadingError = true;
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
    if (newItem != null) {
      setState(() {
        groceryItems.add(newItem);
      });
    } else {
      return;
    }
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
    _isLoadingError = false;
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget bodyContent = Center(
      child: Text(
        'Shopping list is empty.',
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: isDark
                  ? Theme.of(context).colorScheme.primaryFixed
                  : Theme.of(context).colorScheme.primary,
            ),
      ),
    );
    if (_isLoading) {
      bodyContent = const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_isLoadingError) {
      bodyContent = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Center(
          child: Text(
            'Error loading data.\n\nCheck your internet settings or try again after sometime!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
      );
    }
    if (groceryItems.isNotEmpty && !_isLoading && !_isLoadingError) {
      bodyContent = ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ValueKey(groceryItems[index].id),
            direction: DismissDirection.horizontal,
            background: Container(
              color: Theme.of(context).colorScheme.error,
              child: Center(
                child: Text(
                  'Deleting',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            confirmDismiss: (direction) async {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Confirm Deletion',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.errorContainer,
                          ),
                        ),
                      ),
                    ],
                    titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
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
                  border: Border.all(
                    color: Theme.of(context).colorScheme.shadow,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              title: Text(
                groceryItems[index].itemName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Text(
                groceryItems[index].quantity.toString(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shopping List',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.primaryFixed,
              ),
        ),
        leading: const Icon(
          Icons.shopping_cart,
        ),
        titleSpacing: 0,
        actions: [
          IconButton(
            highlightColor: Colors.transparent,
            onPressed: reloadData,
            icon: _isLoading && !_isLoadingError
                ? Container()
                : const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Choose Theme',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...lightColorSchemes.entries.map(
                          (themeItem) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  widget.onThemeChanged(themeItem.key);
                                  Navigator.of(context).pop();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                    contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                    //actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  );
                },
              );
            },
            icon: const Icon(Icons.settings),
          ),
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
