import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../scoped-models/main.dart';
// import '../../widgets/ui_elements/drawer/logout_list_tile.dart';
// import '../../widgets/ui_elements/drawer/ingredients_list_tile.dart';
// import '../../widgets/ui_elements/drawer/recipes_list_tile.dart';
// import '../../widgets/ui_elements/drawer/ingredients_admin_list_tile.dart';
// import '../../widgets/ui_elements/drawer/recipes_admin_list_tile.dart';
// import '../../widgets/ui_elements/drawer/calendar_list_tile.dart';
// import '../../widgets/ui_elements/drawer/images_list_tile.dart';
// import '../../widgets/ui_elements/drawer/videos_list_tile.dart';

class ShoppingListPage extends StatelessWidget {
  final MainModel model;

  ShoppingListPage(this.model);

  @override
  Widget build(BuildContext context) {
    model.updateShopItems();

    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Scaffold(
        // drawer: _buildSideDrawer(context),
        appBar: new AppBar(
          title: new Text('Shopping List'),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget widget, MainModel model) {
            return ListView.builder(
                itemCount: model.getShopItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      CheckboxListTile(
                        secondary: CircleAvatar(
                          backgroundImage:
                              NetworkImage(model.getShopItems[index].image),
                        ),
                        value: model.getShopItems[index].bought,
                        onChanged: (bool value) {
                          model.setSelectedShopItem(index);
                          model.toggleBoughtStatus();
                          model.setSelectedShopItem(null);
                        },
                        title: Text(model.getShopItems[index].name),
                        subtitle: Text(model.getShopItems[index].quantity),
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
//           VideosListTile(),
//           Divider(),
//           ImagesListTile(),
//           Divider(),
//           LogoutListTile(),
//         ],
//       ),
//     ),
//   );
// }
