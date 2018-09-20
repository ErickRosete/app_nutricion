import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../widgets/ingredients/ingredients.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';
import '../../widgets/ui_elements/drawer/videos_list_tile.dart';
import '../../scoped-models/main.dart';

class IngredientsPage extends StatefulWidget {
  final MainModel model;

  IngredientsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _IngredientsPageState();
  }
}

class _IngredientsPageState extends State<IngredientsPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchIngredients();
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
            ImagesListTile(),
            Divider(),
            LogoutListTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No Ingredients Found!'));
        if (model.displayedIngredients.length > 0 && !model.isLoading) {
          content = Ingredients();
        } else if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
            onRefresh: model.fetchIngredients, child: content);
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
          title: Text('App de nutrición'),
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
                IconData favoriteIcon = model.displayIngredientsFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border;
                return IconButton(
                  icon: Icon(favoriteIcon),
                  onPressed: () {
                    model.toggleIngredientDisplayMode();
                  },
                );
              },
            ),
          ],
        ),
        // body: IngredientManager(startingIngredient:'Food Tester')
        body: _buildIngredientsList(),
      ),
    );
  }
}
