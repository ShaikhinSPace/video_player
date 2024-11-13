import 'dart:developer';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerService {
  static final VideoPlayerService _instance = VideoPlayerService._internal();

  late final ValueNotifier<VideoPlayerController> _videoPlayerController;
  late final ValueNotifier<ChewieController?> _chewieController;
  final ValueNotifier<bool> _isPlaying = ValueNotifier<bool>(false);
  Duration? _totalTime;
  final ValueNotifier<Duration> _currentTime =
      ValueNotifier<Duration>(Duration.zero);

  // Private constructor for the singleton pattern
  VideoPlayerService._internal();

  // Factory constructor for singleton access
  factory VideoPlayerService() => _instance;

  // Initialize the controllers
  Future<void> initialize(String videoUrl) async {
    Uri uri = Uri.parse(videoUrl);

    _videoPlayerController =
        ValueNotifier(VideoPlayerController.networkUrl(uri));
    _chewieController = ValueNotifier<ChewieController?>(null);

    await _videoPlayerController.value.initialize();

    _chewieController.value = ChewieController(
      controlsSafeAreaMinimum: const EdgeInsets.all(0),
      videoPlayerController: _videoPlayerController.value,
      showControls: true,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
    );

    // Update current time and total duration when video is playing
    _videoPlayerController.value.addListener(() {
      _currentTime.value = _videoPlayerController.value.value.position;
      _totalTime =
          _chewieController.value!.videoPlayerController.value.duration;
      log('CURRENT TIME:::${_currentTime.value}');
    });
  }

  // Exposed parameters with getters
  ValueNotifier<bool> get isPlaying => _isPlaying;
  Duration? get totalTime => _totalTime;
  ValueNotifier<Duration> get currentTime => _currentTime;
  ValueNotifier<ChewieController?> get chewieController => _chewieController;

  // Control playback functions
  void playPause() {
    if (_chewieController.value != null &&
        !_chewieController.value!.isPlaying) {
      _chewieController.value!.play();
      _isPlaying.value = true;
    } else if (_chewieController.value != null &&
        _chewieController.value!.isPlaying) {
      _chewieController.value!.pause();
      _isPlaying.value = false;
    }
  }

  void seekForward() {
    final currentPos = _videoPlayerController.value.value.position;
    final newPosition = currentPos + const Duration(seconds: 10);
    _videoPlayerController.value.seekTo(newPosition);
  }

  void seekBackward() {
    final currentPos = _videoPlayerController.value.value.position;
    final newPosition = currentPos - const Duration(seconds: 10);
    _videoPlayerController.value.seekTo(newPosition);
  }

  // Format Duration as hh:mm:ss
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  // Dispose controllers
  void dispose() {
    _videoPlayerController.value.dispose();
    _videoPlayerController.dispose();
    _chewieController.value?.dispose();
    _chewieController.dispose();
    _isPlaying.dispose();
    _currentTime.dispose();
  }
}
