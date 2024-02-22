import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/functions/toast_function.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final bool gestureEnabled;
  final bool? playSound;
  final double? aspectRatio;
  const VideoPlayerWidget(
      {super.key,
      required this.videoUrl,
      required this.gestureEnabled,
      this.playSound,
      this.aspectRatio});

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
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: false))
      ..initialize().then((_) {
        setState(() {
          if (widget.gestureEnabled) {
            videoPlayerController!.play();
            if (widget.playSound == true) {
              videoPlayerController!.setVolume(1);
            } else {
              videoPlayerController!.setVolume(0);
            }
          } else {
            videoPlayerController!.play();
            videoPlayerController!.setVolume(0);
          }

          videoPlayerController!.setLooping(true);
        });
      }).onError((error, stackTrace) {
        debugPrint('Error in video player for url: ${widget.videoUrl}');
      });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (videoPlayerController != null) {
      videoPlayerController!.pause();
      videoPlayerController!.setVolume(0);
      videoPlayerController!.removeListener(() {});
      videoPlayerController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return videoPlayerController!.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: widget.aspectRatio ?? 9 / 18,
                child: Stack(
                  children: [
                    GestureDetector(
                        onLongPress: () {
                          if (widget.gestureEnabled) {
                            if (videoPlayerController!.value.isPlaying) {
                              videoPlayerController!.pause();
                            }
                          }
                        },
                        onLongPressEnd: (details) {
                          if (widget.gestureEnabled) {
                            videoPlayerController!.play();
                          }
                        },
                        onTap: () {
                          if (widget.gestureEnabled) {
                            if (videoPlayerController!.value.volume == 1) {
                              videoPlayerController!.setVolume(0);
                              showTransparentDialog(context, true);
                            } else {
                              videoPlayerController!.setVolume(1);
                              showTransparentDialog(context, false);
                            }
                          }
                        },
                        child: VideoPlayer(videoPlayerController!)),
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
                    // bottom seek bar
                  ],
                ),
              ),
              // seek bar
            ],
          )
        : const Center(
            child: CupertinoActivityIndicator(
            radius: 15,
            color: Colors.white,
          ));
  }

  void showTransparentDialog(BuildContext context, bool muted) {
    ToastFunction.showIconToast(
      context,
      muted ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
    );
  }
}
