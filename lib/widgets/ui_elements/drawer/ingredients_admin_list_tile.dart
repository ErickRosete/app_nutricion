import 'package:flutter/material.dart';

class IngredientsAdminListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text("Ingredients Admin"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/ingredientsAdmin');
      },
    );
  }
}
