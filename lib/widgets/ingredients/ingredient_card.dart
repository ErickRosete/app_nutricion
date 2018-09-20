import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../ui_elements/title_default.dart';
import '../ui_elements/image_with_placeholder.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final int ingredientIndex;

  IngredientCard(this.ingredient, this.ingredientIndex);

  Widget _buildTitlePriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(ingredient.title),
        SizedBox(
          width: 8.0,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return IconButton(
          icon: Icon(model.getIngredients[ingredientIndex].isFavorite ||
                  model.displayIngredientsFavoritesOnly
              ? Icons.favorite
              : Icons.favorite_border),
          color: Colors.red,
          onPressed: () {
            model.setSelectedIngredient(
                model.getIngredients[ingredientIndex].id);
            model.toggleIngredientFavoriteStatus();
            model.setSelectedIngredient(null);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed<bool>(context,
                "/Ingredient/" + model.getIngredients[ingredientIndex].id);
          },
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ImageWithPlaceholder(ingredient.image),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: _buildTitlePriceRow(),
                  ),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
