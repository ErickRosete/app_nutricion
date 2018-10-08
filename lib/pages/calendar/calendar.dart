import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
import '../../widgets/calendar/dates.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';
import '../../widgets/ui_elements/drawer/videos_list_tile.dart';

class CalendarPage extends StatefulWidget {
  final MainModel model;

  CalendarPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _CalendarPageState();
  }
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchDates();
  }

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

  Widget _buildDateList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No se encontraron fechas'));
        if (model.getDates.length > 0 && !model.isLoading) {
          content = Dates();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
            onRefresh: model.fetchDates, child: content);
      },
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
        body: _buildDateList(),
      ),
    );
  }
}
