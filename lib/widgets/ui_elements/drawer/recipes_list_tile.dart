import 'package:flutter/material.dart';

class RecipesListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.shop,
        color: Colors.orange.shade600,
      ),
      title: Text("Recipes list"),
      onTap: () {
        Navigator.pushNamed(context, '/');
      },
    );
  }
}
