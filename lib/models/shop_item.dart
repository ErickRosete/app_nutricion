import 'package:flutter/material.dart';

class ShopItem {
  final bool bought;
  final String name;
  final String quantity;
  final String image;


  ShopItem(
      {@required this.name,
      @required this.quantity,
      @required this.image,
      @required this.bought});
}
