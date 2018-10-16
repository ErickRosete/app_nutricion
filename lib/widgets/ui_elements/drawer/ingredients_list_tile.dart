import 'package:flutter/material.dart';

class IngredientsListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.shop,
        color: Colors.orange.shade600,
      ),
      title: Text("Ingredients list"),
      onTap: () {
        Navigator.pushNamed(context, '/ingredients');
      },
    );
  }
}
