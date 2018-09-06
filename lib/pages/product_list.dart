import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_form.dart';
import '../models/product.dart';
import '../scoped-models/products.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildEditButton(
      BuildContext context, int index, Function selectProduct) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        selectProduct(index);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProductFormPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget widget, ProductsModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final Product product = model.products[index];
            return Dismissible(
              key: Key(product.title),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(index);
                  model.deleteProduct();
                }
              },
              background: Container(color: Colors.red),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(product.image),
                    ),
                    title: Text(product.title),
                    subtitle: Text('\$${product.price}'),
                    trailing:
                        _buildEditButton(context, index, model.selectProduct),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }
}
