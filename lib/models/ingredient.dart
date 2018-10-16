import 'package:flutter/material.dart';

class Ingredient {
  final int id;
  final String name;
  final String description;
  final String image;
  final double quantity;
  final String unit;
  final double calories;
  final bool isFavorite;
  final String category;

  Ingredient(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.image,
      @required this.quantity,
      @required this.unit,
      @required this.calories,
      @required this.category,
      this.isFavorite = false});
}
