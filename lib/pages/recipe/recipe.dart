import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../../widgets/ui_elements/title_default.dart';
import '../../widgets/ui_elements/image_with_placeholder.dart';
import '../../models/recipe.dart';
import '../../models/ingredient.dart';
import '../../scoped-models/main.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  final String timeToEat;
  final MainModel model;

  RecipePage(this.recipe, this.model, [this.timeToEat = "Alimento"]);

  @override
  State<StatefulWidget> createState() {
    return _RecipePageState();
  }
}

class _RecipePageState extends State<RecipePage> {
  @override
  initState() {
    super.initState();
    widget.model.updateUserModifier();
  }

  List<Widget> getDropdownButtons() {
    List<Widget> dropdownButtons = new List<Widget>();

    for (int i = 0; i < widget.recipe.ingredients.length; i++) {
      Ingredient ingredient = widget.recipe.ingredients[i];
      dropdownButtons.add(
        DropdownButton<Ingredient>(
          value: ingredient,
          items: widget.model
              .getEquivalentIngredients(ingredient.category)
              .map((Ingredient eqIng) {
            return new DropdownMenuItem<Ingredient>(
              value: eqIng,
              child: new Text(eqIng.name +
                  "     " +
                  widget.model.getIngredientQuantity(eqIng).toString() +
                  " " +
                  eqIng.unit),
            );
          }).toList(),
          onChanged: (selectedIngredient) {
            setState(() {
              widget.recipe.ingredients[i] = selectedIngredient;
            });
          },
        ),
      );
    }

    return dropdownButtons;
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
          title: Text(widget.timeToEat),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                  icon: Icon(model.getRecipeById(widget.recipe.id).isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: Colors.red,
                  onPressed: () {
                    model.setSelectedRecipe(widget.recipe.id);
                    model.toggleRecipeFavoriteStatus();
                    model.setSelectedRecipe(null);
                  },
                );
              },
            ),
          ],
        ),
        // body: RecipeManager(startingRecipe:'Food Tester')
        body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.all(10.0),
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  ImageWithPlaceholder(widget.recipe.image),
                  SizedBox(height: 10.0),
                  TitleDefault(widget.recipe.name),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Ingredientes',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Oswald',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: getDropdownButtons(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Procedimiento',
                          style: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Oswald',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            widget.recipe.directions,
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ],
              )),
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

//   Widget _buildAddressPriceRow(Recipe recipe) {
//     // double calories = 0.0;
// //          recipe.ingredients.forEach((ing) => calories += ing.calories);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: <Widget>[
//         Text(
//           'Ingredientes',
//           style: TextStyle(
//             color: Colors.grey,
//             fontFamily: 'Oswald',
//           ),
//         ),
//         // Text(
//         //   '$calories cal',
//         //   style: TextStyle(
//         //     color: Colors.grey,
//         //     fontFamily: 'Oswald',
//         //   ),
//         // ),
//       ],
//     );
//   }

// RaisedButton(
//   onPressed: () {
//     Navigator.pushNamed<bool>(
//         context,
//         "/Recipe/" +
//             widget.recipe.id.toString() +
//             "/Ingredients");
//   },
//   child: Text("View Ingredients"),
// ),

// <Widget>[
//   DropdownButton<String>(
//     value: selectedString1,
//     items: <String>[
//       'Carne de cerdo     40g',
//       'Cecina de res     50g',
//       'Pepperoni     10 reb.'
//     ].map((String value) {
//       return new DropdownMenuItem<String>(
//         value: value,
//         child: new Text(value),
//       );
//     }).toList(),
//     onChanged: (String selected) {
//       setState(() {
//         selectedString1 = selected;
//       });
//     },
//   ),
//   DropdownButton<String>(
//     value: selectedString2,
//     items: <String>[
//       'Leche     1 taza',
//       'Leche clavel     1/2 taza',
//       'Yogurt natural     1 taza'
//     ].map((String value) {
//       return new DropdownMenuItem<String>(
//         value: value,
//         child: new Text(value),
//       );
//     }).toList(),
//     onChanged: (String selected) {
//       setState(() {
//         selectedString2 = selected;
//       });
//     },
//   ),
//   DropdownButton<String>(
//     value: selectedString3,
//     items: <String>[
//       'Ajonjolí     4 cdits',
//       'Chilorio     30g',
//       'Chorizo     15g'
//     ].map((String value) {
//       return new DropdownMenuItem<String>(
//         value: value,
//         child: new Text(value),
//       );
//     }).toList(),
//     onChanged: (String selected) {
//       setState(() {
//         selectedString3 = selected;
//       });
//     },
//   ),
//   DropdownButton<String>(
//     value: selectedString4,
//     items: <String>[
//       'Chicharo    1/2 taza',
//       'Frijoles refritos     1/3 taza',
//       'Soya cocida     1/3 taza'
//     ].map((String value) {
//       return new DropdownMenuItem<String>(
//         value: value,
//         child: new Text(value),
//       );
//     }).toList(),
//     onChanged: (String selected) {
//       setState(() {
//         selectedString4 = selected;
//       });
//     },
//   ),
// ],
