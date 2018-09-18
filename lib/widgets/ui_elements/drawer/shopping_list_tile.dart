import 'package:flutter/material.dart';

class ShoppingListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.shopping_cart),
      title: Text("Shopping list"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/shoppingList');
      },
    );
  }
}
