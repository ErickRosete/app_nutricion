import 'package:flutter/material.dart';

import '../scoped-models/main.dart';
import './product_form.dart';
import './product_list.dart';
import '../widgets/ui_elements/logout_list_tile.dart';

class ProductAdminPage extends StatelessWidget {
  final MainModel model;

  ProductAdminPage(this.model);

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
            title: Text("Products list"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
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
          title: Text('Product Manager'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              icon: Icon(Icons.create),
              text: 'Create Product',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'My Products',
            ),
          ]),
        ),
        // body: ProductManager(startingProduct:'Food Tester')
        body: TabBarView(
          children: <Widget>[
            ProductFormPage(),
            ProductListPage(model),
          ],
        ),
      ),
    );
  }
}
