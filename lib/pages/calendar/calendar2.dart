import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scrolling_calendar/scrolling_calendar.dart';

import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';
import '../../widgets/ui_elements/drawer/videos_list_tile.dart';

class CalendarPage extends StatelessWidget {
  static final Random random = new Random();

  static Iterable<Color> randomColors() => <Color>[]
    ..addAll(random.nextBool() ? <Color>[] : <Color>[Colors.red])
    ..addAll(random.nextBool() ? <Color>[] : <Color>[Colors.blue])
    ..addAll(random.nextBool() ? <Color>[] : <Color>[Colors.green]);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text("Choose"),
            ),
            Image.asset('assets/placeholder_logo.png', height: 100.0),
            Divider(),
            RecipesListTile(),
            Divider(),
            IngredientsListTile(),
            Divider(),
            RecipesAdminListTile(),
            Divider(),
            IngredientsAdminListTile(),
            Divider(),
            ShoppingListTile(),
            Divider(),
            VideosListTile(),
            Divider(),
            ImagesListTile(),
            Divider(),
            LogoutListTile(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text("Calendar"),
        ),
        // body: IngredientManager(startingIngredient:'Food Tester')
        body: new ScrollingCalendar(
            firstDayOfWeek: DateTime.monday,
            onDateTapped: (DateTime date) =>
                Navigator.pushNamed(context, '/calendarDay'),
            selectedDate: new DateTime(2018, 9, 18),
            colorMarkers: (_) => randomColors()),
      ),
    );
  }
}
