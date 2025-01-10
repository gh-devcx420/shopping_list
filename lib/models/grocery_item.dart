import 'package:shopping_list/models/category_model.dart';

class GroceryItem {
  GroceryItem({
    required this.id,
    required this.itemName,
    required this.category,
    required this.quantity,
  });

  String id;
  String itemName;
  Category category;
  int quantity;
}
