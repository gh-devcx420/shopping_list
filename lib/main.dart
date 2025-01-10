import 'package:flutter/material.dart';
import 'package:shopping_list/screens/shopping_list_home.dart';

void main() {
  runApp(
    const ShoppingList(),
  );
}

class ShoppingList extends StatelessWidget {
  const ShoppingList({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShoppingListHomeScreen(),
    );
  }
}
