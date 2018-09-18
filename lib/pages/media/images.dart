import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../widgets/media/image-card.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/videos_list_tile.dart';

class ImagesPage extends StatelessWidget {
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
            VideosListTile(),
            Divider(),
            LogoutListTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageList(BuildContext context, List<Recipe> recipes) {
    Widget recipeCards;
    if (recipes.length > 0) {
      recipeCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ImageCard(recipes[index], index),
        itemCount: recipes.length,
      );
    } else {
      recipeCards = Center(
        child: Text("No images found, please add some"),
      );
    }
    return recipeCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return _buildImageList(context, model.displayedRecipes);
      }),
    );
  }
}
