import 'package:flutter/material.dart';

class ImageWithPlaceholder extends StatelessWidget {
  final String image;
  final double height;

  ImageWithPlaceholder(this.image, {this.height});

  @override
  Widget build(BuildContext context) {

    return FadeInImage(
      image: NetworkImage(image),
      placeholder: AssetImage('assets/placeholder.png'),
      height: height,
      fit: height == null ? BoxFit.fitWidth : null,
    );
  }
}
