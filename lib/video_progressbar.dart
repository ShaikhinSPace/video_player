// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoProgressBar extends StatefulWidget {
//   VideoProgressBar(
//     this.controller, {
//     ChewieProgressColors? colors,
//     this.onDragEnd,
//     this.onDragStart,
//     this.onDragUpdate,
//     this.draggableProgressBar = true,
//     super.key,
//     required this.barHeight,
//     required this.handleHeight,
//     required this.drawShadow,
//   }) : colors = colors ?? ChewieProgressColors();

//   final VideoPlayerController controller;
//   final ChewieProgressColors colors;
//   final Function()? onDragStart;
//   final Function()? onDragEnd;
//   final Function()? onDragUpdate;

//   final double barHeight;
//   final double handleHeight;
//   final bool drawShadow;
//   final bool draggableProgressBar;

//   @override
//   // ignore: library_private_types_in_public_api
//   _VideoProgressBarState createState() {
//     return _VideoProgressBarState();
//   }
// }

// class _VideoProgressBarState extends State<VideoProgressBar> {
//   void listener() {
//     if (!mounted) return;
//     setState(() {});
//   }

//   bool _controllerWasPlaying = false;

//   Offset? _latestDraggableOffset;

//   VideoPlayerController get controller => widget.controller;

//   @override
//   void initState() {
//     super.initState();
//     controller.addListener(listener);
//   }

//   @override
//   void deactivate() {
//     controller.removeListener(listener);
//     super.deactivate();
//   }

//   void _seekToRelativePosition(Offset globalPosition) {
//     final box = context.findRenderObject() as RenderBox;
//     final Offset tapPosition = box.globalToLocal(globalPosition);
//     final double relativePosition =
//         (tapPosition.dx / box.size.width).clamp(0, 1);
//     final Duration position = controller.value.duration * relativePosition;
//     return position;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final child = Center(
//       child: StaticProgressBar(
//         value: controller.value,
//         colors: widget.colors,
//         barHeight: widget.barHeight,
//         handleHeight: widget.handleHeight,
//         drawShadow: widget.drawShadow,
//         latestDraggableOffset: _latestDraggableOffset,
//       ),
//     );

//     return widget.draggableProgressBar
//         ? GestureDetector(
//             onHorizontalDragStart: (DragStartDetails details) {
//               if (!controller.value.isInitialized) {
//                 return;
//               }
//               _controllerWasPlaying = controller.value.isPlaying;
//               if (_controllerWasPlaying) {
//                 controller.pause();
//               }

//               widget.onDragStart?.call();
//             },
//             onHorizontalDragUpdate: (DragUpdateDetails details) {
//               if (!controller.value.isInitialized) {
//                 return;
//               }
//               _latestDraggableOffset = details.globalPosition;
//               listener();

//               widget.onDragUpdate?.call();
//             },
//             onHorizontalDragEnd: (DragEndDetails details) {
//               if (_controllerWasPlaying) {
//                 controller.play();
//               }

//               if (_latestDraggableOffset != null) {
//                 _seekToRelativePosition(_latestDraggableOffset!);
//                 _latestDraggableOffset = null;
//               }

//               widget.onDragEnd?.call();
//             },
//             onTapDown: (TapDownDetails details) {
//               if (!controller.value.isInitialized) {
//                 return;
//               }
//               _seekToRelativePosition(details.globalPosition);
//             },
//             child: child,
//           )
//         : child;
//   }
// }
