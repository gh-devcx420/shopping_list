import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category_model.dart';
import 'package:shopping_list/models/grocery_item.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String _itemName = '';
  int _quantity = 0;
  var _selectedCategory = GroceryCategory.none;
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  Future<bool> isConnectedToInternet() async {
    final connectionStatus =
        await InternetConnectionChecker.instance.hasConnection;
    return connectionStatus;
  }

  void _showErrorDialogue() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Network Error ',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
          ),
          content: const Text(
            'Check your internet connection & please try after sometime.',
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          contentPadding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        );
      },
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
      try {
        if (await isConnectedToInternet() == false) {
          if (mounted) {
            _showErrorDialogue();
          }
          return;
        }
        final url = Uri.https(
          'shopping-list-d65c7-default-rtdb.firebaseio.com',
          'shopping-list.json',
        );
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'itemName': _itemName,
            'category': shoppingCategories[_selectedCategory]!.title,
            'quantity': _quantity,
          }),
        );
        final Map<String, dynamic> itemID = json.decode(response.body);
        var categoryFromEnum = shoppingCategories.entries.firstWhere((value) {
          return value.key == _selectedCategory;
        });
        if (mounted) {
          Navigator.of(context).pop(
            GroceryItem(
              id: itemID['name'],
              itemName: _itemName,
              category: Category(
                title: categoryFromEnum.value.title,
                categoryColour: categoryFromEnum.value.categoryColour,
              ),
              quantity: _quantity,
            ),
          );
        }
      } catch (error) {
        if (context.mounted) {
          _showErrorDialogue();
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Item Name'),
                ),
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: isDark
                          ? Theme.of(context).colorScheme.primaryFixed
                          : Theme.of(context).colorScheme.primary,
                    ),
                textCapitalization: TextCapitalization.words,
                maxLength: 30,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length < 2 ||
                      value.trim().length > 30) {
                    return 'Item name must be between 1 and 30 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemName = value!;
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: isDark
                                ? Theme.of(context).colorScheme.primaryFixed
                                : Theme.of(context).colorScheme.primary,
                          ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'Quantity must be a valid, positive value';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      validator: (value) {
                        if (value == null || value == GroceryCategory.none) {
                          return 'Must select a category';
                        }
                        return null;
                      },
                      //style: Theme.of(context).textTheme.labelSmall,
                      items: [
                        for (final currentCategory
                            in shoppingCategories.entries)
                          DropdownMenuItem(
                            value: currentCategory.key,
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: currentCategory.value.categoryColour,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  currentCategory.value.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                        color: isDark
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primaryFixed
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        _selectedCategory = value!;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSending
                          ? null
                          : () {
                              _selectedCategory = GroceryCategory.none;
                              _formKey.currentState!.reset();
                            },
                      child: const Text(
                        'Reset',
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(),
                      onPressed: _isSending ? null : _saveForm,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'Save',
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
