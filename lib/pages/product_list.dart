import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_form.dart';
import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;

  ProductListPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchProducts(onlyForUser: true);
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.setSelectedProduct(model.getProducts[index].id);
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProductFormPage(),
          ),
        )
            .then((_) {
          model.setSelectedProduct(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget widget, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final Product product = model.getProducts[index];
            return Dismissible(
              key: Key(product.title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart ||
                    direction == DismissDirection.startToEnd) {
                  model.setSelectedProduct(product.id);
                  model.deleteProduct();
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product.image),
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.getProducts.length,
        );
      },
    );
  }
}
