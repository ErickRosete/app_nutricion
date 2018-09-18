import 'package:flutter/material.dart';

import '../ui_elements/title_default.dart';
import '../ui_elements/image_with_placeholder.dart';
import '../../models/recipe.dart';

class ImageCard extends StatelessWidget {
  final Recipe recipe;
  final int recipeIndex;

  ImageCard(this.recipe, this.recipeIndex);

  Widget _buildTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(recipe.title),
        SizedBox(
          width: 8.0,
        ),
      ],
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
              child: _buildTitleRow(),
            ),
          ],
        ),
      ),
    );
  }
}
