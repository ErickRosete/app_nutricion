import 'package:flutter/material.dart';

class ShoppingListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.shopping_cart,
        color: Colors.orange.shade600,
      ),
      title: Text("Shopping list"),
      onTap: () {
        Navigator.pushNamed(context, '/shoppingList');
      },
    );
  }
}
