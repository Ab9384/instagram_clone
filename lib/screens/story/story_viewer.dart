import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/provider/story_data.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StoryViewer extends StatefulWidget {
  final List<String> images;
  const StoryViewer({Key? key, required this.images}) : super(key: key);

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late PageController pageController;
  List<double> durationInSeconds = [];

  @override
  void initState() {
    super.initState();
    pageController = PageController();

    Provider.of<StoryData>(context, listen: false)
        .initProgress(widget.images.length);
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              Provider.of<StoryData>(context, listen: false).canceTimer();
            } else {}
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return _buildVideo(index);
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 5,
                right: 5,
                child: Consumer<StoryData>(
                  builder: (context, value, child) {
                    return Row(
                      children: List.generate(
                        widget.images.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: LinearProgressIndicator(
                              value: value.progress[index],
                              borderRadius: BorderRadius.circular(10),
                              backgroundColor: Colors.grey,
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(int index) {
    durationInSeconds.insert(index, 5.0);
    return Stack(
      children: [
        Positioned.fill(
          child: ExtendedImage.network(
            widget.images[index],
            fit: BoxFit.cover,
            cache: true,
            enableMemoryCache: true,
            clearMemoryCacheIfFailed: true,
            loadStateChanged: (ExtendedImageState state) {
              debugPrint("Widget built: $index");
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case LoadState.failed:
                  return GestureDetector(
                    child: const Center(
                      child: Text('load image failed, click to reload'),
                    ),
                    onTap: () {
                      state.reLoadImage();
                    },
                  );
                case LoadState.completed:
                  var provider = Provider.of<StoryData>(context, listen: false);
                  if (provider.progress[index] == 0.0) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      provider.updateProgress(
                          index, widget.images.length, durationInSeconds[index],
                          () {
                        moveToNextPage(index);
                      }, mounted, context);
                    });
                  }
                  return ExtendedRawImage(
                    image: state.extendedImageInfo?.image,
                    fit: BoxFit.cover,
                  );
              }
            },
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                moveToPreviousPage(index);
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
            )),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              print("next page");
              moveToNextPage(index);
            },
            onLongPressStart: (details) {
              Provider.of<StoryData>(context, listen: false).canceTimer();
            },
            onLongPressEnd: (details) {
              Provider.of<StoryData>(context, listen: false).updateProgress(
                  index, widget.images.length, durationInSeconds[index], () {
                moveToNextPage(index);
              }, mounted, context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideo(int index) {
    VideoPlayerController? videoPlayerController;
    String videoUrl =
        'https://dl2.instavideosave.com/?url=https%3A%2F%2Fscontent.cdninstagram.com%2Fv%2Ft50.2886-16%2F424956842_762303832444564_1956791748921894790_n.mp4%3F_nc_ht%3Dscontent.cdninstagram.com%26_nc_cat%3D104%26_nc_ohc%3DNGgnSChXFukAX_g07-I%26edm%3DAPs17CUBAAAA%26ccb%3D7-5%26oh%3D00_AfC_XqiOzQvHPfnYzk3Qk3SCFImsncf6jqFIaCqsk4JICA%26oe%3D65DF6FE9%26_nc_sid%3D10d13b';

    return Stack(
      children: [
        Positioned.fill(
          child: FutureBuilder<VideoPlayerController>(
            future: _initializeVideoPlayer(videoUrl),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading video'));
              } else {
                videoPlayerController = snapshot.data!;
                final duration =
                    videoPlayerController!.value.duration.inSeconds.toDouble();
                durationInSeconds.insert(index, duration);
                final provider = Provider.of<StoryData>(context, listen: false);

                if (provider.progress[index] == 0.0) {
                  videoPlayerController!.play();
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    provider.updateProgress(
                        index, widget.images.length, durationInSeconds[index],
                        () {
                      moveToNextPage(index);
                    }, mounted, context);
                  });
                }

                return VideoPlayer(videoPlayerController!);
              }
            },
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                moveToPreviousPage(index);
                if (videoPlayerController != null) {
                  videoPlayerController!.pause();
                  videoPlayerController!.dispose();
                }
              },
              onLongPressStart: (details) {
                Provider.of<StoryData>(context, listen: false).canceTimer();
                if (videoPlayerController != null) {
                  videoPlayerController!.pause();
                }
              },
              onLongPressEnd: (details) {
                Provider.of<StoryData>(context, listen: false).updateProgress(
                    index, widget.images.length, durationInSeconds[index], () {
                  moveToNextPage(index);
                }, mounted, context);
                if (videoPlayerController != null) {
                  videoPlayerController!.play();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height,
                color: Colors.transparent,
              ),
            )),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              moveToNextPage(index);
              if (videoPlayerController != null) {
                videoPlayerController!.pause();
                videoPlayerController!.dispose();
              }
            },
            onLongPressStart: (details) {
              Provider.of<StoryData>(context, listen: false).canceTimer();
              if (videoPlayerController != null) {
                videoPlayerController!.pause();
              }
            },
            onLongPressEnd: (details) {
              Provider.of<StoryData>(context, listen: false).updateProgress(
                  index, widget.images.length, durationInSeconds[index], () {
                moveToNextPage(index);
              }, mounted, context);
              if (videoPlayerController != null) {
                videoPlayerController!.play();
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Future<VideoPlayerController> _initializeVideoPlayer(String videoUrl) async {
    final videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(videoUrl));
    await videoPlayerController.initialize();
    return videoPlayerController;
  }

  moveToNextPage(int index) {
    Provider.of<StoryData>(context, listen: false)
        .canceTimer(); // cancel the timer
    if (mounted) {
      if (index < widget.images.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        Provider.of<StoryData>(context, listen: false)
            .updateProgressManually(index, 1.0);
      } else {
        Navigator.pop(context);
      }
    }
  }

  moveToPreviousPage(int index) {
    Provider.of<StoryData>(context, listen: false)
        .canceTimer(); // cancel the timer
    if (mounted) {
      if (index > 0) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        Provider.of<StoryData>(context, listen: false)
            .updateProgressManually(index - 1, 0.0);
        Provider.of<StoryData>(context, listen: false)
            .updateProgressManually(index, 0.0);
      } else {
        Navigator.pop(context);
      }
    }
  }
}
