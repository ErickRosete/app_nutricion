import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../ui_elements/title_default.dart';
import '../ui_elements/calorie_tag.dart';
import '../ui_elements/image_with_placeholder.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class IngredientCard extends StatelessWidget {
  final Ingredient ingredient;
  final int ingredientIndex;

  IngredientCard(this.ingredient, this.ingredientIndex);

  Widget _buildTitlePriceRow(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CalorieTag(ingredient.calories.toString()),
          TitleDefault(ingredient.name),
          SizedBox(
            width: 8.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed<bool>(
                context,
                "/Ingredient/" +
                    model.getIngredients[ingredientIndex].id.toString());
          },
          child: Card(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ImageWithPlaceholder(ingredient.image),
                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: _buildTitlePriceRow(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
