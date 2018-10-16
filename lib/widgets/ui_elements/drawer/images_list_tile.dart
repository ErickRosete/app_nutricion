import 'package:flutter/material.dart';

class ImagesListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.image,
        color: Colors.orange.shade600,
      ),
      title: Text("Images"),
      onTap: () {
        Navigator.pushNamed(context, '/images');
      },
    );
  }
}
