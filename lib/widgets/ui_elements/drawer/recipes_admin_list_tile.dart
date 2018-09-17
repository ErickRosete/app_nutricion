import 'package:flutter/material.dart';

class RecipesAdminListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text("Recipes Admin"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/recipesAdmin');
      },
    );
  }
}
