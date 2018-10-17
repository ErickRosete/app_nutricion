import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../widgets/media/video-card.dart';
import '../../models/recipe.dart';
import '../../scoped-models/main.dart';
// import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
// import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
// import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
// import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
// import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
// import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
// import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
// import '../../widgets/ui_elements/drawer/images_list_tile.dart';

class VideosPage extends StatelessWidget {


  // Widget _buildSideDrawer(BuildContext context) {
  //   return Drawer(
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           AppBar(
  //             automaticallyImplyLeading: false,
  //             title: Text("Choose"),
  //           ),
  //           Image.asset('assets/placeholder_logo.png', height: 100.0),
  //           Divider(),
  //           RecipesListTile(),
  //           Divider(),
  //           IngredientsListTile(),
  //           Divider(),
  //           RecipesAdminListTile(),
  //           Divider(),
  //           IngredientsAdminListTile(),
  //           Divider(),
  //           CalendarListTile(),
  //           Divider(),
  //           ShoppingListTile(),
  //           Divider(),
  //           ImagesListTile(),
  //           Divider(),
  //           LogoutListTile(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildVideoList(BuildContext context, List<Recipe> recipes) {
    Widget recipeCards;
    if (recipes.length > 0) {
      recipeCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            VideoCard(recipes[index], index),
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Scaffold(
        // drawer: _buildSideDrawer(context),
        appBar: new AppBar(
          title: new Text('Videos'),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget widget, MainModel model) {
            return _buildVideoList(context, model.getRecipes);
          },
        ),
      ),
    );
  }
}
