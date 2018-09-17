import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './recipe_card.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class Recipes extends StatelessWidget {
  Widget _buildRecipeList(BuildContext context, List<Recipe> recipes) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 1.80;
    final double itemWidth = size.width / 2;

    Widget recipeCards;
    if (recipes.length > 0) {
      recipeCards = GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (itemWidth / itemHeight),
        ),
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
        return _buildRecipeList(context, model.displayedRecipes);
      },
    );
  }
}
