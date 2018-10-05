import 'package:flutter/material.dart';

class Ingredient {
  final int id;
  final String name;
  final String description;
  final String image;
  final String quantity;
  final double calories;
  final bool isFavorite;

  Ingredient(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.image,
      @required this.quantity,
      @required this.calories,
      this.isFavorite = false});
}
