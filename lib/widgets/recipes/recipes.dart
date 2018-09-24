import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './recipe_card.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class Recipes extends StatelessWidget {
  Widget _buildRecipeList(BuildContext context, List<Recipe> recipes, bool displayRecipesFavoritesOnly) {
    Widget recipeCards;

    if (recipes.length > 0) {
      recipeCards = OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              childAspectRatio: displayRecipesFavoritesOnly? 1.1 : .88,
            ),
            itemBuilder: (BuildContext context, int index) =>
                RecipeCard(recipes[index], index),
            itemCount: recipes.length,
          );
        },
      );
    } else {
      recipeCards = Center(
        child: Text("No Recipes found, please add some"),
      );
    }
    return recipeCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildRecipeList(context, model.displayedRecipes, model.displayRecipesFavoritesOnly);
      },
    );
  }
}
