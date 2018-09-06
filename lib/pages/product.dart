import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/ui_elements/title_default.dart';
import '../scoped-models/products.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final int index;

  ProductPage(this.index);

  Widget _buildAddressPriceRow(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          'Union Square, San Francisco',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Oswald',
          ),
        ),
        Text(
          '\$${product.price.toString()}',
          style: TextStyle(
            color: Colors.grey,
            fontFamily: 'Oswald',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, ProductsModel model) {
          final Product product = model.products[index];
          return Scaffold(
            appBar: AppBar(
              title: Text(product.title),
            ),
            // body: ProductManager(startingProduct:'Food Tester')
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Image.asset(product.image),
                  TitleDefault(product.title),
                  SizedBox(height: 10.0),
                  _buildAddressPriceRow(product),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      product.description,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// _showWarningDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Are you sure?'),
//         content: Text('This action cannot be undone!'),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('CANCEL'),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           FlatButton(
//             child: Text('CONTINUE'),
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.pop(context, true);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
