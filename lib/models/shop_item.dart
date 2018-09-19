import 'package:flutter/material.dart';

import './ingredient.dart';

class ShopItem {
  final Ingredient ingredient;
  final bool bought;


  ShopItem(
      {@required this.ingredient,
      @required this.bought});
}
