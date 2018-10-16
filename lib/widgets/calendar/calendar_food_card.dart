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
        var color = Colors.amber.shade100;
        if (food.timeToEat.split('-')[0] == 'Merienda') {
          color = Colors.deepOrange.shade50;
        }

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed<bool>(
                context, "/Recipe/" + food.recipe.id.toString() + "/${food.timeToEat.split('-')[0]}");
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
            child: Card(
              color: color,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(4.0),
                    child: ImageWithPlaceholder(
                      food.recipe.image,
                      height: landscape
                          ? 100.0
                          : (MediaQuery.of(context).size.height - 250) / 5,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: color,
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
                              food.recipe.name,
                              textAlign: TextAlign.center,
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
          ),
        );
      },
    );
  }
}
