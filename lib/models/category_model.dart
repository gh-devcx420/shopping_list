import 'package:flutter/material.dart';

enum GroceryCategory {
  none,
  vegetables,
  fruit,
  meat,
  dairy,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  Category({required this.title, required this.categoryColour});

  String title;
  Color categoryColour;
}
