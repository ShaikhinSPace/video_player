import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({super.key, required this.videoUrl});

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  final ValueNotifier<VideoPlayerController> _videoPlayerController =
      ValueNotifier<VideoPlayerController>(
          VideoPlayerController.networkUrl(Uri()));
  final ValueNotifier<ChewieController> _chewieController =
      ValueNotifier<ChewieController>(ChewieController(
    // materialProgressColors: ChewieProgressColors(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     handleColor: Colors.white,
    //     bufferedColor: Colors.blueGrey,
    //     playedColor: Colors.white),
    aspectRatio: 16 / 9,
    videoPlayerController: VideoPlayerController.networkUrl(Uri()),
    autoPlay: false,
    looping: false,
  ));

  @override
  void initState() {
    _initVideoPlayer();
    super.initState();
  }

  _initVideoPlayer() {
    _chewieController.value =
        ChewieController(videoPlayerController: _videoPlayerController.value);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 200,
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(25)),
      child: Chewie(
        controller: _chewieController.value,
      ),
    );
  }
}
