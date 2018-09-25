import 'package:flutter/material.dart';

import './recipe.dart';

class Food {
  final Recipe recipe;
  final String timeToEat;

  Food({
    @required this.recipe,
    @required this.timeToEat,
  });
}

// Map<String, int> timeToEatMapping = {
//   "Desayuno": 0,
//   "Merienda-1": 1,
//   "Comida": 2,
//   "Merienda-2": 3,
//   "Cena": 4,
// };
