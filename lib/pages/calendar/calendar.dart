import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../../models/date.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';
import '../../widgets/ui_elements/drawer/videos_list_tile.dart';

class CalendarPage extends StatelessWidget {
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

  Image _dayImage(DateTime date) {
    return Image.asset(
      "assets/icons/" + DateFormat('EEEE').format(date) + ".png",
      fit: BoxFit.contain,
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
          body: ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              if (model.getDates.length < 1) model.calculateDays();

              return ListView.builder(
                itemCount: model.getDates.length,
                itemBuilder: (context, index) {
                  final Date date = model.getDates[index];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: _dayImage(date.dateTime),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(DateFormat.yMMMMd("es").format(date.dateTime)),
                        subtitle: Text(DateFormat.EEEE('es').format(date.dateTime)),
                        onTap: () {
                          model.setSelectedDate(index);
                          Navigator.pushNamed(context, '/calendarDay');
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              );
            },
          )),
    );
  }
}
