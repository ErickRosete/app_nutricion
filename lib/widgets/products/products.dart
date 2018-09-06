import 'package:flutter/material.dart';

import './product_card.dart';
import '../../models/product.dart';

class Products extends StatelessWidget {
  final List<Product> products;
  // Variable inside [] means can be initialized automatically, and it is not necessarily needed
  Products(this.products);

  @override
  Widget build(BuildContext context) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Center(
        child: Text("No products found, please add some"),
      );
    }
    return productCards;
  }
}
