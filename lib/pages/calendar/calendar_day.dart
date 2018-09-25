import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../../widgets/calendar/calendar_food_card.dart';
import '../../models/food.dart';
import '../../scoped-models/main.dart';

class CalendarDayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          appBar: AppBar(
            title: Text(DateFormat.MMMMEEEEd('es')
                .format(model.getSelectedDate.dateTime)),
          ),
          // body: IngredientManager(startingIngredient:'Food Tester')
          body: ListView.builder(
            itemCount: model.getSelectedDate.foods.length,
            itemBuilder: (BuildContext context, int index) {
              final Food food = model.getSelectedDate.foods[index];
              return CalendarFoodCard(food);
            },
          ));
    });
  }
}
