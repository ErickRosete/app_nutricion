import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';
import 'package:side_header_list_view/side_header_list_view.dart';
import 'package:flutter/material.dart';

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
        body: new SideHeaderListView(
          itemCount: model.getSelectedDate.foods.length,
          padding: new EdgeInsets.all(16.0),
          itemExtend: 48.0,
          headerBuilder: (BuildContext context, int index) {
            return new SizedBox(
                width: 140.0,
                child: new Text(
                  model.getSelectedDate.foods[index].timeToEat.split('-')[0],
                  style: Theme.of(context).textTheme.headline,
                ));
          },
          itemBuilder: (BuildContext context, int index) {
            return new Text(
              model.getSelectedDate.foods[index].recipe.title,
              style: Theme.of(context).textTheme.headline,
            );
          },
          hasSameHeader: (int a, int b) {
            return model.getSelectedDate.foods[a].timeToEat ==
                model.getSelectedDate.foods[b].timeToEat;
          },
        ),
      );
    });
  }
}
