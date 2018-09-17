import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './ingredient_card.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class Ingredients extends StatelessWidget {
  Widget _buildIngredientList(BuildContext context, List<Ingredient> ingredients) {
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 1.80;
    final double itemWidth = size.width / 2;

    Widget ingredientCards;
    if (ingredients.length > 0) {
      ingredientCards = GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
        itemBuilder: (BuildContext context, int index) =>
            IngredientCard(ingredients[index], index),
        itemCount: ingredients.length,
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