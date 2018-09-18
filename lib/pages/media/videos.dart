import 'package:flutter/material.dart';

import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';

class VideosPage extends StatelessWidget {
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
            CalendarListTile(),
            Divider(),
            ShoppingListTile(),
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
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text("Videos"),
      ),
      // body: IngredientManager(startingIngredient:'Food Tester')
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Text("Videos"),
            ),
          ],
        ),
      ),
    );
  }
}
