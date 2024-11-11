import 'dart:developer';

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
  late final ValueNotifier<VideoPlayerController> _videoPlayerController;
  late final ValueNotifier<ChewieController?> _chewieController;
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);
  final ValueNotifier<Duration> currentTime =
      ValueNotifier<Duration>(Duration.zero);

  @override
  void initState() {
    super.initState();
    Uri uri = Uri.parse(widget.videoUrl);

    // Initialize the video player controller with the provided URL
    _videoPlayerController = ValueNotifier(
      VideoPlayerController.networkUrl(uri),
    );

    // Initialize the Chewie controller after the video player is initialized
    _chewieController = ValueNotifier<ChewieController?>(null);
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    await _videoPlayerController.value.initialize();
    _chewieController.value = ChewieController(
      placeholder: FlutterLogo(),
      controlsSafeAreaMinimum: const EdgeInsets.all(0),
      videoPlayerController: _videoPlayerController.value,
      showControls: false,
      autoPlay: false,
      looping: false,
    );
    _videoPlayerController.value.addListener(() {
      currentTime.value =
          _videoPlayerController.value.value.position ?? Duration.zero;
    });
    log('CURRENTTIME:::${currentTime.value}');
  }

  void _playPause() {
    if (_chewieController.value != null &&
        !_chewieController.value!.isPlaying) {
      _chewieController.value!.play();
      isPlaying.value = true;
    } else if (_chewieController.value != null &&
        _chewieController.value!.isPlaying) {
      _chewieController.value!.pause();
      isPlaying.value = false;
    }
    log('CURRENTTIME:::${currentTime.value}');
  }

  void _seekForward() {
    final currentPos =
        _videoPlayerController.value.value.position ?? Duration.zero;
    final newPosition = currentPos + Duration(seconds: 5);
    _videoPlayerController.value.seekTo(newPosition);
  }

  @override
  void dispose() {
    _videoPlayerController.value.dispose();
    _videoPlayerController.dispose();
    _chewieController.value?.dispose();
    _chewieController.dispose();
    isPlaying.dispose();
    currentTime.dispose();
    super.dispose();
  }

  // Helper function to format the Duration as hh:mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(25),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: ValueListenableBuilder<ChewieController?>(
              valueListenable: _chewieController,
              builder: (context, chewieController, child) {
                if (chewieController != null &&
                    chewieController
                        .videoPlayerController.value.isInitialized) {
                  return Stack(
                    children: [
                      Chewie(controller: chewieController),
                      Positioned(
                        bottom: 110,
                        right: 0,
                        child: Text(
                          "WaterMark",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  );
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              onPressed: () {},
              icon: const Icon(Icons.skip_previous, color: Colors.black),
              label: const Text(""),
            ),
            ValueListenableBuilder(
              valueListenable: isPlaying,
              builder: (context, playing, _) {
                return ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  onPressed: _playPause,
                  icon: Icon(
                    playing ? Icons.pause : Icons.play_arrow,
                    color: Colors.black,
                  ),
                  label: const Text(""),
                );
              },
            ),
            ElevatedButton.icon(
              onPressed: _seekForward,
              icon: const Icon(Icons.skip_next, color: Colors.black),
              label: const Text(""),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
          ],
        ),
        ValueListenableBuilder(
          valueListenable: currentTime,
          builder: (context, time, _) {
            return Text(
              _formatDuration(time),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),
      ],
    );
  }
}
