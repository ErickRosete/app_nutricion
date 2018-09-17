import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import './address_tag.dart';
import '../ui_elements/title_default.dart';
import '../ui_elements/image_with_placeholder.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final int recipeIndex;

  RecipeCard(this.recipe, this.recipeIndex);

  Widget _buildTitlePriceRow() {
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
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.info),
              color: Colors.blue,
              onPressed: () {
                Navigator.pushNamed<bool>(
                    context, "/Recipe/" + model.getRecipes[recipeIndex].id);
              },
            ),
            IconButton(
              icon: Icon(model.getRecipes[recipeIndex].isFavorite || model.displayRecipesFavoritesOnly
                  ? Icons.favorite
                  : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                model.setSelectedRecipe(model.getRecipes[recipeIndex].id);
                model.toggleRecipeFavoriteStatus();
                model.setSelectedRecipe(null);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ImageWithPlaceholder(recipe.image),
            SizedBox(height: 10.0),
            Container(
              margin: EdgeInsets.only(top: 10.0),
              child: _buildTitlePriceRow(),
            ),
            AddressTag('Union Square, San Francisco'),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }
}
