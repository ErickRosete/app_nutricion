import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

// import './address_tag.dart';
import '../ui_elements/calorie_tag.dart';
import '../ui_elements/title_default.dart';
import '../ui_elements/image_with_placeholder.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int recipeIndex;

  RecipeCard(this.recipe, this.recipeIndex);

  Widget _buildTitleCaloriesRow(BuildContext context) {
    double calories = 0.0;
//          recipe.ingredients.forEach((ing) => calories += ing.calories);
    return Container (
      width: MediaQuery.of(context).size.width * .45,
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CalorieTag(calories.toString()),
        TitleDefault(recipe.name),
        SizedBox(
          width: 8.0,
        ),
      ],
    ),);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed<bool>(context,
                "/Recipe/" + model.getRecipes[recipeIndex].id.toString());
          },
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ImageWithPlaceholder(recipe.image),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: _buildTitleCaloriesRow(context),
                  ),
                  // AddressTag('Union Square, San Francisco'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
