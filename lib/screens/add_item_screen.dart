import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });
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
      await Future.delayed(
        const Duration(seconds: 2), //to observe loading spinner
      );
      var itemID = json.decode(response.body);
      var categoryFromEnum = shoppingCategories.entries.firstWhere((value) {
        return value.key == _selectedCategory;
      });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  label: Text('Item Name'),
                ),
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
                height: 4,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        label: Text('Quantity'),
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
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                      ),
                      value: _selectedCategory,
                      validator: (value) {
                        if (value == null || value == GroceryCategory.none) {
                          return 'Must select a category';
                        }
                        return null;
                      },
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
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Text(currentCategory.value.title),
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
                height: 20,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                      ),
                      onPressed: _isSending ? null : _saveForm,
                      child: _isSending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(),
                            )
                          : const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                              ),
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
