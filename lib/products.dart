import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final List<String> products;

  // Variable inside [] means can be initialized automatically, and it is not necessarily needed 
  Products([this.products = const []]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: products
          .map(
            (element) => Card(
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/food.jpg'),
                      Text(element)
                    ],
                  ),
                ),
          )
          .toList(),
    );
  }
}
