import 'package:flutter/material.dart';
import 'dart:async';

import '../../widgets/ui_elements/title_default.dart';
import '../../widgets/ui_elements/image_with_placeholder.dart';
import '../../models/recipe.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage(this.recipe);

  Widget _buildAddressPriceRow(Recipe recipe) {
    double calories = 0.0;
//          recipe.ingredients.forEach((ing) => calories += ing.calories);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Oswald',
          ),
        ),
        Text(
          '$calories cal',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Oswald',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(recipe.name),
        ),
        // body: RecipeManager(startingRecipe:'Food Tester')
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ImageWithPlaceholder(recipe.image),
              TitleDefault(recipe.name),
              SizedBox(height: 10.0),
              _buildAddressPriceRow(recipe),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  recipe.directions,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.pushNamed<bool>(
                      context, "/Recipe/" + recipe.id.toString() + "/Ingredients");
                },
                child: Text("View Ingredients"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// _showWarningDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Are you sure?'),
//         content: Text('This action cannot be undone!'),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('CANCEL'),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           FlatButton(
//             child: Text('CONTINUE'),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context, true);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
