import 'package:flutter/material.dart';

import '../../scoped-models/main.dart';
import './ingredient_form.dart';
import './ingredient_list.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';

class IngredientsAdminPage extends StatelessWidget {
  final MainModel model;

  IngredientsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
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
          LogoutListTile(),
          Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Ingredient Manager'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              icon: Icon(Icons.create),
              text: 'Create Ingredient',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'My Ingredients',
            ),
          ]),
        ),
        // body: IngredientManager(startingIngredient:'Food Tester')
        body: TabBarView(
          children: <Widget>[
            IngredientFormPage(),
            IngredientListPage(model),
          ],
        ),
      ),
    );
  }
}
