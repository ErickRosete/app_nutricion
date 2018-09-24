import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
// import './address_tag.dart';
import '../ui_elements/title_default.dart';
import '../ui_elements/image_with_placeholder.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int recipeIndex;

  RecipeCard(this.recipe, this.recipeIndex);

  Widget _buildTitlePriceRow(BuildContext context) {
    var size = MediaQuery.of(context).size;

    if (size.width > 320) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(recipe.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(recipe.price.toString()),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TitleDefault(recipe.title),
          SizedBox(
            width: 8.0,
          ),
          PriceTag(recipe.price.toString()),
          SizedBox(
            width: 15.0,
          ),
        ],
      );
    }
  }

  Widget _buildActionButtons(BuildContext context, MainModel model) {
    return !model.displayRecipesFavoritesOnly
        ? IconButton(
            icon: Icon(model.getRecipes[recipeIndex].isFavorite
                ? Icons.favorite
                : Icons.favorite_border),
            color: Colors.red,
            onPressed: () {
              model.setSelectedRecipe(model.getRecipes[recipeIndex].id);
              model.toggleRecipeFavoriteStatus();
              model.setSelectedRecipe(null);
            },
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed<bool>(
                context, "/Recipe/" + model.getRecipes[recipeIndex].id);
          },
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ImageWithPlaceholder(recipe.image),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: _buildTitlePriceRow(context),
                  ),
                  // AddressTag('Union Square, San Francisco'),
                  _buildActionButtons(context, model),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
