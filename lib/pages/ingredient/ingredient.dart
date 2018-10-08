import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../../widgets/ui_elements/title_default.dart';
import '../../widgets/ui_elements/image_with_placeholder.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class IngredientPage extends StatelessWidget {
  final Ingredient ingredient;

  IngredientPage(this.ingredient);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(ingredient.name),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                  icon: Icon(model.getIngredientById(ingredient.id).isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {
                    model.setSelectedIngredient(ingredient.id);
                    model.toggleIngredientFavoriteStatus();
                    model.setSelectedIngredient(null);
                  },
                );
              },
            ),
          ],
        ),
        // body: IngredientManager(startingIngredient:'Food Tester')
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ImageWithPlaceholder(ingredient.image),
              TitleDefault(ingredient.name),
              SizedBox(height: 10.0),
              ingredient.description != null
                  ? Container(
                      margin: EdgeInsets.all(10.0),
                      child: Text(
                        ingredient.description,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
