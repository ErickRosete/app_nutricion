import 'package:flutter/material.dart';

class IngredientsListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.shop),
      title: Text("Ingredients list"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/ingredients');
      },
    );
  }
}
