import 'package:flutter/material.dart';

import './ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final String directions;
  final String image;
  final bool isFavorite;
  final List<Ingredient> ingredients;

  Recipe(
      {@required this.id,
      @required this.name,
      @required this.directions,
      @required this.image,
      this.isFavorite = false,
      @required this.ingredients
      });
}
