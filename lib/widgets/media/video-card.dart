import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';

import '../../models/recipe.dart';

class VideoCard extends StatelessWidget {
  final Recipe recipe;
  final int recipeIndex;

  VideoCard(this.recipe, this.recipeIndex);

  void playYoutubeVideo() {
    FlutterYoutube.playYoutubeVideoByUrl(
      apiKey: "AIzaSyAsVjYW1xnpfyv0tKbAbYChqFKThpvWKMY",
      videoUrl: "https://www.youtube.com/watch?v=fhWaJi1Hsfo",
      autoPlay: true, //default falase
      // fullScreen: true
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: playYoutubeVideo,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        constraints: new BoxConstraints.expand(
            height: MediaQuery.of(context).size.height / 4),
        alignment: Alignment.bottomCenter,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new NetworkImage(recipe.image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.play_circle_outline,
                size: 100.0,
                color: Colors.white,
              ),
              Text(
                recipe.name,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 26.0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
