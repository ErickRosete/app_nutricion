import 'package:flutter/material.dart';
import 'dart:async';

import '../../widgets/ui_elements/title_default.dart';
import '../../widgets/ui_elements/image_with_placeholder.dart';
import '../../models/recipe.dart';

class RecipePage extends StatelessWidget {
  final Recipe recipe;

  RecipePage(this.recipe);

  Widget _buildAddressPriceRow(Recipe recipe) {
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
          '\$${recipe.price.toString()}',
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
          title: Text(recipe.title),
        ),
        // body: RecipeManager(startingRecipe:'Food Tester')
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ImageWithPlaceholder(recipe.image, 200.0),
              TitleDefault(recipe.title),
              SizedBox(height: 10.0),
              _buildAddressPriceRow(recipe),
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  recipe.description,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              RaisedButton(
                onPressed: () {
                Navigator.pushNamed<bool>(
                    context, "/Recipe/" + recipe.id + "/Ingredients");
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
