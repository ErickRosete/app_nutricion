import 'package:flutter/material.dart';

class VideosListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.video_library),
      title: Text("Videos"),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/videos');
      },
    );
  }
}
