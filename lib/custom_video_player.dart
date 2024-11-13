import 'package:ag_video_player/video_player_service.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';

class CustomVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const CustomVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _CustomVideoPlayerState createState() {
    return _CustomVideoPlayerState();
  }
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  final videoService = VideoPlayerService();

  @override
  void initState() {
    super.initState();
    videoService.initialize(widget.videoUrl);
  }

  @override
  void dispose() {
    videoService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<ChewieController?>(
          valueListenable: videoService.chewieController,
          builder: (context, chewieController, _) {
            if (chewieController != null &&
                chewieController.videoPlayerController.value.isInitialized) {
              return Chewie(controller: chewieController);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        ValueListenableBuilder<Duration>(
          valueListenable: videoService.currentTime,
          builder: (context, time, _) {
            return Text(
              "${videoService.formatDuration(time)}/${videoService.totalTime != null ? videoService.formatDuration(videoService.totalTime!) : '00:00:00'}",
            );
          },
        ),
      ],
    );
  }
}
