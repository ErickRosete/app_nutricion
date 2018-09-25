import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../ui_elements/image_with_placeholder.dart';
import '../../models/food.dart';
import '../../scoped-models/main.dart';

class CalendarFoodCard extends StatelessWidget {
  final Food food;

  CalendarFoodCard(this.food);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        bool landscape = MediaQuery.of(context).size.width >=
            MediaQuery.of(context).size.height;
        MaterialColor color;
        switch (food.timeToEat.split('-')[0]) {
          case "Desayuno":
            {
              color = Colors.yellow;
              break;
            }
          case "Merienda":
            {
              color = Colors.orange;
              break;
            }
          case "Comida":
            {
              color = Colors.green;
              break;
            }
          case "Cena":
            {
              color = Colors.deepPurple;
              break;
            }
          default:
            {
              color = Colors.white;
              break;
            }
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed<bool>(context, "/Recipe/" + food.recipe.id);
          },
          child: Card(
            color: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              children: <Widget>[
                ImageWithPlaceholder(
                  food.recipe.image,
                  height: landscape
                      ? 100.0
                      : (MediaQuery.of(context).size.height - 125) / 5,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          color.withOpacity(0.3),
                          BlendMode.dstATop,
                        ),
                        image: AssetImage('assets/placeholder_logo.png'),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(5.0),
                          child: Text(
                            food.timeToEat.split('-')[0],
                            style: TextStyle(
                                fontSize: 26.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(5.0),
                          child: Text(
                            food.recipe.title,
                            style: TextStyle(fontSize: 22.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
