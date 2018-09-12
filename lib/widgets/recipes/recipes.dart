import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './recipe_card.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class Recipes extends StatelessWidget {
  Widget _buildRecipeList(List<Recipe> recipes) {
    Widget recipeCards;
    if (recipes.length > 0) {
      recipeCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            RecipeCard(recipes[index], index),
        itemCount: recipes.length,
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
        return _buildRecipeList(model.displayedRecipes);
      },
    );
  }
}
