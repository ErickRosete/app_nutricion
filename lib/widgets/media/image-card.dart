import 'package:flutter/material.dart';

import '../../models/recipe.dart';

class ImageCard extends StatelessWidget {
  final Recipe recipe;
  final int recipeIndex;

  ImageCard(this.recipe, this.recipeIndex);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      constraints: new BoxConstraints.expand(
          height: MediaQuery.of(context).size.height / 4),
      alignment: Alignment.bottomCenter,
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: new NetworkImage(recipe.image),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(.7),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          recipe.title,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: Colors.white,
            fontSize: 26.0,
          ),
        ),
      ),
    );
  }
}
