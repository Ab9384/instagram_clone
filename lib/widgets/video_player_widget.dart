import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.videoUrl,
        ),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        setState(() {
          // videoPlayerController!.play();
          // videoPlayerController!.setLooping(true);
          // videoPlayerController!.setVolume(50);
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (videoPlayerController != null) videoPlayerController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController!.value.isInitialized
        ? AspectRatio(
            aspectRatio: 9 / 18,
            child: Stack(
              children: [
                VideoPlayer(videoPlayerController!),
                // reel icon top right
                Positioned(
                  top: 10,
                  right: 10,
                  child: ExtendedImage.asset(
                    'assets/icons/reel_filled.png',
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )
        : const Center(child: CupertinoActivityIndicator());
  }
}
