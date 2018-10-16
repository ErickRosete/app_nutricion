import 'package:flutter/material.dart';

class User {
  final int id;
  final String email;
  final String token;
  final Map<String, dynamic> modifier;

  User({
    @required this.id,
    @required this.email,
    @required this.token,
    this.modifier,
  });
}
