import 'package:flutter/material.dart';

class User {
  final int id;
  final String email;
  final String token;

  User({
    @required this.id,
    @required this.email,
    @required this.token,
  });
}
