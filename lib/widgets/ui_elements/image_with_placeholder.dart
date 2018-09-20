import 'package:flutter/material.dart';

class ImageWithPlaceholder extends StatelessWidget {
  final String image;

  ImageWithPlaceholder(this.image);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      image: NetworkImage(image),
      placeholder: AssetImage('assets/placeholder.png'),
      fit: BoxFit.fitWidth,
    );
  }
}
