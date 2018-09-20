import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './ingredient_card.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class Ingredients extends StatelessWidget {
  Widget _buildIngredientList(BuildContext context, List<Ingredient> ingredients) {

    Widget ingredientCards;
    if (ingredients.length > 0) {
      ingredientCards =       OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              childAspectRatio: 0.80,
            ),
            itemBuilder: (BuildContext context, int index) =>
                IngredientCard(ingredients[index], index),
            itemCount: ingredients.length,
          );
        },
      );
    } else {
      ingredientCards = Center(
        child: Text("No Ingredients found, please add some"),
      );
    }
    return ingredientCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildIngredientList(context, model.displayedIngredients);
      },
    );
  }
}