import 'package:flutter/material.dart';

class IngredientsAdminListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.edit,
        color: Colors.orange.shade600,
      ),
      title: Text("Ingredients Admin"),
      onTap: () {
        Navigator.pushNamed(context, '/ingredientsAdmin');
      },
    );
  }
}
