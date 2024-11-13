import 'package:ag_video_player/theme.dart';
import 'package:ag_video_player/custom_video_player.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: myThemeData,
    debugShowCheckedModeBanner: false,
    home: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Video Player Application',
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w700,
              fontSize: 25),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8.0),
        child: CustomVideoPlayer(
            videoUrl:
                "https://demo.unified-streaming.com/k8s/features/stable/video/tears-of-steel/tears-of-steel.ism/.m3u8"),
      ),
    );
  }
}
