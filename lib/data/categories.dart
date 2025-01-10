import 'package:flutter/material.dart';
import 'package:shopping_list/models/category_model.dart';

Map<GroceryCategory, Category> shoppingCategories = {
  GroceryCategory.none: Category(
    title: 'None',
    categoryColour: const Color.fromARGB(255, 189, 189, 189),
  ),
  GroceryCategory.vegetables: Category(
    title: 'Vegetables',
    categoryColour: const Color.fromARGB(255, 0, 255, 128),
  ),
  GroceryCategory.fruit: Category(
    title: 'Fruit',
    categoryColour: const Color.fromARGB(255, 145, 255, 0),
  ),
  GroceryCategory.meat: Category(
    title: 'Meat',
    categoryColour: const Color.fromARGB(255, 255, 102, 0),
  ),
  GroceryCategory.dairy: Category(
    title: 'Dairy',
    categoryColour: const Color.fromARGB(255, 0, 208, 255),
  ),
  GroceryCategory.sweets: Category(
    title: 'Sweets',
    categoryColour: const Color.fromARGB(255, 255, 149, 0),
  ),
  GroceryCategory.spices: Category(
    title: 'Spices',
    categoryColour: const Color.fromARGB(255, 255, 187, 0),
  ),
  GroceryCategory.convenience: Category(
    title: 'Convenience',
    categoryColour: const Color.fromARGB(255, 191, 0, 255),
  ),
  GroceryCategory.hygiene: Category(
    title: 'Hygiene',
    categoryColour: const Color.fromARGB(255, 149, 0, 255),
  ),
  GroceryCategory.other: Category(
    title: 'Other',
    categoryColour: const Color.fromARGB(255, 0, 225, 255),
  ),
};
