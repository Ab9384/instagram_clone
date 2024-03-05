import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:extended_image/extended_image.dart';
import 'package:provider/provider.dart';
import 'package:instagram_clone/provider/story_data.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/provider/app_data.dart';

class StoryViewer extends StatefulWidget {
  final int currentStoryPage;
  final StoryModel story;
  final PageController storyPageController;
  const StoryViewer({
    Key? key,
    required this.currentStoryPage,
    required this.story,
    required this.storyPageController,
  }) : super(key: key);

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late PageController pageController;
  List<double> durationInSeconds = [];
  VideoPlayerController? videoPlayerController;

  @override
  void initState() {
    super.initState();

    pageController = PageController();
    durationInSeconds =
        List<double>.generate(widget.story.storyItems.length, (index) => 0.0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      List<double> storyProgress =
          Provider.of<StoryData>(context, listen: false)
              .progress[widget.currentStoryPage]!;
      int currentStory = storyProgress.indexWhere((element) => element < 1.0);
      print("currentStorIndex: $currentStory");
      if (currentStory != -1) {
        Provider.of<StoryData>(context, listen: false)
            .updateProgressManually(currentStory, widget.currentStoryPage, 0.0);
        pageController.jumpToPage(currentStory);
        for (int i = 0; i < storyProgress.length; i++) {
          if (i > currentStory) {
            Provider.of<StoryData>(context, listen: false)
                .updateProgressManually(i, widget.currentStoryPage, 0.0);
          }
        }
      } else {
        for (int i = 0; i < storyProgress.length; i++) {
          Provider.of<StoryData>(context, listen: false)
              .updateProgressManually(i, widget.currentStoryPage, 0.0);
        }
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    videoPlayerController?.dispose(); // Dispose video player controller
    // Provider.of<StoryData>(context, listen: false).cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              Provider.of<StoryData>(context, listen: false).cancelTimer();
              videoPlayerController?.dispose();
            } else {}
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.story.storyItems.length,
                  itemBuilder: (context, index) {
                    return widget.story.storyItems[index].type == 'image'
                        ? _buildImage(index, widget.currentStoryPage)
                        : _buildVideo(index);
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 5,
                right: 5,
                child: Consumer<StoryData>(
                  builder: (context, value, child) {
                    debugPrint("progresss: ${value.progress}");
                    return Row(
                      children: List.generate(
                        widget.story.storyItems.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: LinearProgressIndicator(
                              value: value
                                  .progress[widget.currentStoryPage]![index],
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

  Widget _buildImage(int index, int storyPage) {
    durationInSeconds.insert(index, 5.0);
    return Stack(
      children: [
        Positioned.fill(
          child: ExtendedImage.network(
            widget.story.storyItems[index].url,
            fit: BoxFit.cover,
            cache: false,
            enableMemoryCache: false,
            clearMemoryCacheIfFailed: false,
            loadStateChanged: (ExtendedImageState state) {
              debugPrint("Widget built: $index");
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return const Center(
                    child: CupertinoActivityIndicator(),
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
                  debugPrint("current image progress: ${provider.progress}");
                  if (provider.progress[provider.storyPage]![index] < 1.0) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      if (mounted) {
                        provider.updateProgress(
                            index, storyPage, durationInSeconds[index], () {
                          moveToNextPage(index);
                        }, mounted, context);
                      }
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
            onLongPressStart: (details) {
              Provider.of<StoryData>(context, listen: false).pauseTimer();
            },
            onLongPressEnd: (details) {
              Provider.of<StoryData>(context, listen: false).resumeTimer(
                  index, widget.currentStoryPage, durationInSeconds[index], () {
                moveToNextPage(index);
              }, context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              moveToNextPage(index);
            },
            onLongPressStart: (details) {
              Provider.of<StoryData>(context, listen: false).pauseTimer();
            },
            onLongPressEnd: (details) {
              Provider.of<StoryData>(context, listen: false).resumeTimer(
                  index, widget.currentStoryPage, durationInSeconds[index], () {
                moveToNextPage(index);
              }, context);
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
    String videoUrl = widget.story.storyItems[index].url;
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

                if (provider.progress[provider.storyPage]![index] == 0.0) {
                  videoPlayerController!.play();
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    provider.updateProgress(index, widget.currentStoryPage,
                        durationInSeconds[index], () {
                      moveToNextPage(index);
                    }, mounted, context);
                  });
                }
                if (provider.progress[provider.storyPage]![index] >= 1.0) {
                  videoPlayerController!.pause();
                  videoPlayerController!.dispose();
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
              videoPlayerController?.pause();
            },
            onLongPressStart: (details) {
              Provider.of<StoryData>(context, listen: false).pauseTimer();
              videoPlayerController?.pause();
            },
            onLongPressEnd: (details) {
              Provider.of<StoryData>(context, listen: false).resumeTimer(index,
                  widget.story.storyItems.length, durationInSeconds[index], () {
                moveToNextPage(index);
              }, context);
              videoPlayerController?.play();
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              color: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              moveToNextPage(index);
              videoPlayerController?.pause();
            },
            onLongPressStart: (details) {
              Provider.of<StoryData>(context, listen: false).pauseTimer();
              videoPlayerController?.pause();
            },
            onLongPressEnd: (details) {
              Provider.of<StoryData>(context, listen: false).resumeTimer(index,
                  widget.story.storyItems.length, durationInSeconds[index], () {
                moveToNextPage(index);
              }, context);
              videoPlayerController?.play();
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
    videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl)); // Change to network instead of networkUrl
    await videoPlayerController!.initialize();
    return videoPlayerController!;
  }

  disposeVideoPlayer() {
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
  }

  moveToNextPage(int index) {
    if (mounted) {
      // Provider.of<StoryData>(context, listen: false)
      //     .cancelTimer(); // cancel the timer
      if (index < widget.story.storyItems.length - 1) {
        pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        Provider.of<StoryData>(context, listen: false)
            .updateProgressManually(index, widget.currentStoryPage, 1.0);
      } else {
        if (widget.storyPageController.page !=
            Provider.of<AppData>(context, listen: false).storiesList.length -
                1) {
          widget.storyPageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          Navigator.pop(context);
        }
      }
    }
  }

  moveToPreviousPage(int index) {
    // Provider.of<StoryData>(context, listen: false)
    //     .cancelTimer(); // cancel the timer
    if (mounted) {
      if (index > 0) {
        pageController.previousPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
        Provider.of<StoryData>(context, listen: false)
            .updateProgressManually(index - 1, widget.currentStoryPage, 0.0);
        Provider.of<StoryData>(context, listen: false)
            .updateProgressManually(index, widget.currentStoryPage, 0.0);
      } else {
        if (widget.storyPageController.page != 0) {
          widget.storyPageController.previousPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
        } else {
          Navigator.pop(context);
        }
      }
    }
  }
}
