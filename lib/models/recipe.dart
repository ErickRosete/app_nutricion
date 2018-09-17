import 'package:flutter/material.dart';

import './ingredient.dart';

class Recipe {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;
  final String userEmail;
  final String userId;
  final List<Ingredient> ingredients;

  Recipe(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.image,
      this.isFavorite = false,
      @required this.userEmail,
      @required this.userId,
      @required this.ingredients
      });
}
