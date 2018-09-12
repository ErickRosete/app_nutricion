import 'package:flutter/material.dart';

import '../scoped-models/main.dart';
import './recipe_form.dart';
import './recipe_list.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class RecipeAdminPage extends StatelessWidget {
  final MainModel model;

  RecipeAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text("Choose"),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Recipes list"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          LogoutListTile(),
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
          title: Text('Recipe Manager'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              icon: Icon(Icons.create),
              text: 'Create Recipe',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'My Recipes',
            ),
          ]),
        ),
        // body: RecipeManager(startingRecipe:'Food Tester')
        body: TabBarView(
          children: <Widget>[
            RecipeFormPage(),
            RecipeListPage(model),
          ],
        ),
      ),
    );
  }
}
