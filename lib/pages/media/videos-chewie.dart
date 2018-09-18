import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
import '../../widgets/ui_elements/drawer/shopping_list_tile.dart';
import '../../widgets/ui_elements/drawer/images_list_tile.dart';

class VideosPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _VideosPageState();
  }
}

class _VideosPageState extends State<VideosPage> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new VideoPlayerController.network(
      'https://github.com/flutter/assets-for-api-docs/blob/master/assets/videos/butterfly.mp4?raw=true',
    );
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
    return new Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: new AppBar(
        title: new Text("Videos"),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new Center(
              child: new Chewie(
                _controller,
                aspectRatio: 3 / 2,
                autoPlay: true,
                looping: true,
                placeholder: new Container(
                  color: Colors.grey,
                ),
                //showControls: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
