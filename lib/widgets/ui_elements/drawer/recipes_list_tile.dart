import 'package:flutter/material.dart';

class RecipesListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.shop),
      title: Text("Recipes list"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    );
  }
}
