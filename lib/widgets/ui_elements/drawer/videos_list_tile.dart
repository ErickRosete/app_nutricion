import 'package:flutter/material.dart';

class VideosListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.video_library,
        color: Colors.orange.shade600,
      ),
      title: Text("Videos"),
      onTap: () {
        Navigator.pushNamed(context, '/videos');
      },
    );
  }
}
