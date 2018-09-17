import 'package:flutter/material.dart';
import 'dart:async';

import '../../widgets/ui_elements/title_default.dart';
import '../../widgets/ui_elements/image_with_placeholder.dart';
import '../../models/ingredient.dart';

class IngredientPage extends StatelessWidget {
  final Ingredient ingredient;

  IngredientPage(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(ingredient.title),
        ),
        // body: IngredientManager(startingIngredient:'Food Tester')
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ImageWithPlaceholder(ingredient.image, 200.0),
              TitleDefault(ingredient.title),
              SizedBox(height: 10.0),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  ingredient.description,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
