import 'package:flutter/material.dart';

class ImagesListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.image),
      title: Text("Images"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/images');
      },
    );
  }
}
