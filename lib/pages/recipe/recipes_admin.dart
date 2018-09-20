import 'package:flutter/material.dart';

import '../../scoped-models/main.dart';
import './recipe_form.dart';
import './recipe_list.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';
import '../../widgets/ui_elements/drawer/videos_list_tile.dart';

class RecipesAdminPage extends StatelessWidget {
  final MainModel model;

  RecipesAdminPage(this.model);

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
            IngredientsAdminListTile(),
            Divider(),
            CalendarListTile(),
            Divider(),
            ShoppingListTile(),
            Divider(),
            VideosListTile(),
            Divider(),
            ImagesListTile(),
            Divider(),
            LogoutListTile(),
            Divider(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () {
          Navigator.pushReplacementNamed(context, '/');
        },
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
      ),
    );
  }
}
