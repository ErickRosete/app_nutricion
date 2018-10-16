import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../../widgets/calendar/calendar_food_card.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';
import '../../widgets/ui_elements/drawer/videos_list_tile.dart';
import '../../models/food.dart';
import '../../scoped-models/main.dart';

class TodayPage extends StatefulWidget {
  final MainModel model;

  TodayPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _TodayPageState();
  }
}

class _TodayPageState extends State<TodayPage> {
  @override
  initState() {
    super.initState();
    if (widget.model.getCurrentDate == null) {
      widget.model.fetchIngredients().then((_) {
        widget.model.fetchRecipes().then((_) {
          widget.model.fetchDates();
        });
      });
    }
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              color: Color.fromARGB(255, 128, 204, 43),
              child: Column(children: <Widget>[
                SizedBox(height: 30.0),
                Image.asset('assets/logo.jpg', height: 100.0),
              ]),
            ),
            SizedBox(
              height: 20.0,
              child: new Center(
                child: new Container(
                  margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 2.0,
                  color: Colors.deepOrange.shade50,
                ),
              ),
            ),
            CalendarListTile(),
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
      onWillPop: _onWillPop,
      child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text("Dia no encontrado"));
        if (model.getDates.length > 0 && !model.isLoading) {
          content = ListView.builder(
            itemCount: model.getCurrentDate.foods.length,
            itemBuilder: (BuildContext context, int index) {
              final Food food = model.getCurrentDate.foods[index];
              return CalendarFoodCard(food);
            },
          );
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            title: Text('Plan de alimentación')
          ),
          body: content,
        );
      }),
    );
  }
}
