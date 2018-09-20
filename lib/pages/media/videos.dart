import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../models/recipe.dart';
import '../../scoped-models/main.dart';
import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';

class VideosPage extends StatelessWidget {
  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyAsVjYW1xnpfyv0tKbAbYChqFKThpvWKMY",
      videoUrl: "https://www.youtube.com/watch?v=fhWaJi1Hsfo",
      autoPlay: true, //default falase
      // fullScreen: true
    );
  }

  Widget _buildViewVideoButton(
      BuildContext context, int index, MainModel model) {
    return IconButton(
        icon: Icon(Icons.video_label),
        onPressed: () {
          playYoutubeVideo();
        });
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: new AppBar(
          title: new Text('Videos'),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget widget, MainModel model) {
            return ListView.builder(
                itemCount: model.getRecipes.length,
                itemBuilder: (BuildContext context, int index) {
                  final Recipe recipe = model.getRecipes[index];
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(recipe.image),
                        ),
                        title: Text(recipe.title),
                        trailing: _buildViewVideoButton(context, index, model),
                      ),
                      Divider(),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
