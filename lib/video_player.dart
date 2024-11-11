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
      controlsSafeAreaMinimum: const EdgeInsets.all(0),
      videoPlayerController: _videoPlayerController.value,
      // aspectRatio: 4 / 3,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    // Dispose of both controllers when done
    _videoPlayerController.value.dispose();
    _videoPlayerController.dispose();
    _chewieController.value?.dispose();
    _chewieController.dispose();
    super.dispose();
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
          child: Expanded(
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
                          bottom:
                              100 + 10, // adjust position based on preference
                          right: 0, // adjust position based on preference
                          child: Text(
                            "WaterMark",
                            style: TextStyle(
                              color: Colors.white.withOpacity(
                                  0.3), // semi-transparent watermark
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodyLarge!.color,
                )),
                onPressed: () {},
                label: const Icon(
                  Icons.skip_previous,
                  color: Colors.black,
                )),
            ElevatedButton.icon(
                style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                  Theme.of(context).textTheme.bodyLarge!.color,
                )),
                onPressed: () {
                  _chewieController.value?.pause();
                },
                label: const Icon(
                  Icons.play_arrow,
                  color: Colors.black,
                )),
            ElevatedButton.icon(
              onPressed: () {},
              label: const Icon(
                Icons.skip_next,
                color: Colors.black,
              ),
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                Theme.of(context).textTheme.bodyLarge!.color,
              )),
            ),
          ],
        )
      ],
    );
  }
}
