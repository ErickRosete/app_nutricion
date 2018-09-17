import 'package:flutter/material.dart';

import '../../models/ingredient.dart';
import '../../models/recipe.dart';
import '../../widgets/ingredients/ingredient_card.dart';

class RecipeIngredientsListPage extends StatelessWidget {
  final Recipe recipe;

  RecipeIngredientsListPage(this.recipe);

  Widget _buildIngredientList(
      BuildContext context, List<Ingredient> ingredients) {
    var size = MediaQuery.of(context).size;

    double itemHeight = 0.0;
    double itemWidth = 0.0;
    int crossAxisCount = 0;

    if (size.width < 500) {
      crossAxisCount = 2;
      /*24 is for notification bar on Android*/
      itemHeight = (size.height - kToolbarHeight - 24) / 2.0;
      itemWidth = size.width / crossAxisCount;
    } else {
      crossAxisCount = 3;
      itemHeight = (size.height - kToolbarHeight - 24);
      itemWidth = size.width / crossAxisCount;
    }

    Widget ingredientCards;
    if (ingredients.length > 0) {
      ingredientCards = GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
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
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.title + " - Ingredients"),
        ),
        // body: RecipeManager(startingRecipe:'Food Tester')
        body: _buildIngredientList(context, recipe.ingredients));
  }
}
