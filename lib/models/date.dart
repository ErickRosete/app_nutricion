import 'package:flutter/material.dart';

import './food.dart';

class Date {
  final DateTime dateTime;
  final List<Food> foods;

  Date({
    @required this.dateTime,
    @required this.foods,
  });
}
