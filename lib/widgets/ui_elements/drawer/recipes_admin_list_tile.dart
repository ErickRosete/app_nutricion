import 'package:flutter/material.dart';

class RecipesAdminListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.edit,
        color: Colors.orange.shade600,
      ),
      title: Text("Recipes Admin"),
      onTap: () {
        Navigator.pushNamed(context, '/recipesAdmin');
      },
    );
  }
}
