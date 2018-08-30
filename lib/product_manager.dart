import 'package:flutter/material.dart';

import './products.dart';

class ProductManager extends StatefulWidget {
  final String startingProduct;

// Variable inside {} means that a variable should be send with name (useful with multiple variables)
// ProductManager(startingProduct:'Food Tester')
  ProductManager({this.startingProduct = "Sweet Tester"});
  // ProductManager(this.startingProduct)



  @override
  State<StatefulWidget> createState() {
    return _ProductManagerState();
  }
}

class _ProductManagerState extends State<ProductManager> {
  List<String> _products = [];

  @override
    void initState() {
      super.initState();
      _products.add(widget.startingProduct);
    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: RaisedButton(
            //color: Theme.of(context).buttonColor,
            child: Text('Add Product'),
            onPressed: () {
              setState(() {
                _products.add("Advanced Food Tester");
              });
            },
          ),
        ),
        Products(_products)
      ],
    );
  }
}
