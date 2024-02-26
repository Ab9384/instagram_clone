import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/widgets/video_player_widget.dart';
import 'package:provider/provider.dart';

class StoryViewScreen extends StatefulWidget {
  const StoryViewScreen({Key? key}) : super(key: key);

  @override
  State<StoryViewScreen> createState() => _StoryViewScreenState();
}

class _StoryViewScreenState extends State<StoryViewScreen> {
  late PageController _pageController;
  double _currentPageValue = 0.0;

  @override
  void initState() {
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page!;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> images =
        Provider.of<AppData>(context, listen: false).imageList;
    List<String> videos =
        Provider.of<AppData>(context, listen: false).videoList;
    // List<StoryItemData> selectedImages = [
    //   StoryItemData(url: images[0], isVideo: false),
    //   StoryItemData(url: videos[0], isVideo: true),
    // ];
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: 3,
          itemBuilder: (context, index) {
            final progress = index - _currentPageValue;
            final rotationY = lerpDouble(0, 30, progress)!;
            const maxOpacity = 0.8;
            final opacity = lerpDouble(0, maxOpacity, progress.abs())!
                .clamp(0.0, maxOpacity);
            final isPaging = opacity != maxOpacity;
            final transform = Matrix4.identity();
            transform.setEntry(3, 2, 0.003);
            transform.rotateY(-rotationY * (pi / 180.0));
            return Transform(
              alignment:
                  progress <= 0 ? Alignment.centerRight : Alignment.centerLeft,
              transform: transform,
              child: StoryViewer(images: images, opacity: opacity),
            );
          },
        ),
      ),
    );
  }
}

class StoryViewer extends StatefulWidget {
  const StoryViewer({
    super.key,
    required this.images,
    required this.opacity,
  });

  final List<String> images;

  final double opacity;

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  PageController storyController =
      PageController(initialPage: 0, viewportFraction: 1.0);
  List<double> progress = [0.0, 0.0];
  List<int> durations = [5, 5];
  Timer? _timer;
  @override
  void dispose() {
    _timer?.cancel();
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
            itemCount: 2,
            controller: storyController,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, itemIndex) {
              if (progress[itemIndex] < 1.0) {
                _timer = Timer.periodic(const Duration(milliseconds: 10),
                    (timer) async {
                  if (mounted) {
                    setState(() {
                      if (progress[itemIndex] < 1.0) {
                        progress[itemIndex] = progress[itemIndex] +
                            durations[itemIndex] /
                                (100000.0 * durations[itemIndex]);
                      } else {
                        progress[itemIndex] = 1.0;
                        timer.cancel();
                      }
                    });
                  }
                });
              }
              if (progress[itemIndex] == 1.0) {
                _timer?.cancel();
                print('Story $itemIndex completed');
                storyController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }

              return Stack(
                children: [
                  ExtendedImage.network(
                    widget.images[itemIndex],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                  ),
                  Positioned(
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        storyController.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height,
                        child: ColoredBox(
                          color: Colors.black.withOpacity(0.0),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        storyController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.height,
                        child: ColoredBox(
                          color: Colors.blue.withOpacity(0.0),
                        ),
                      ),
                    ),
                  ),

                  // progress bar for all stories in the list
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 10,
                    child: Row(
                      children: List.generate(
                        2,
                        (indicatorIndex) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Column(
                              children: [
                                LinearProgressIndicator(
                                  value: progress[indicatorIndex],
                                  backgroundColor: Colors.black12,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Story ${indicatorIndex + 1}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ],
    );
  }
}

// class StoryItemViewer extends StatelessWidget {
//   const StoryItemViewer({
//     Key? key,
//     required this.selectedImages,
//     required this.masterPageController,
//     required this.maxPage,
//     required this.currentPage,
//   }) : super(key: key);

//   final List<StoryItemData> selectedImages;
//   final PageController masterPageController;
//   final int maxPage;
//   final int currentPage;

//   @override
//   Widget build(BuildContext context) {
//     final storyItemController =
//         PageController(initialPage: 0, viewportFraction: 1.0);
//     return PageView.builder(
//       itemCount: selectedImages.length,
//       controller: storyItemController,
//       physics: const NeverScrollableScrollPhysics(),
//       itemBuilder: (context, index) {
//         return Stack(
//           children: [
//             Positioned.fill(
//               child: StoryItem(
//                 image: selectedImages[index],
//                 storyItemController: storyItemController,
//                 masterPageController: masterPageController,
//                 maxStoryItem: selectedImages.length - 1,
//                 currentStoryItem: index,
//                 currentPage: currentPage,
//                 maxPages: maxPage,
//               ),
//             ),
//             // // progress bar for all stories in the list
//             // Positioned(
//             //   left: 0,
//             //   right: 0,
//             //   top: 10,
//             //   child: Row(
//             //     children: List.generate(
//             //       selectedImages.length,
//             //       (indicatorIndex) => Expanded(
//             //         child: Padding(
//             //           padding: const EdgeInsets.symmetric(horizontal: 2),
//             //           child: LinearProgressIndicatorWidget(
//             //             value: getProgress(
//             //                 storyController: storyItemController,
//             //                 index: indicatorIndex),
//             //             maxValue: 1,
//             //           ),
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//           ],
//         );
//       },
//     );
//   }

//   double getProgress(
//       {required PageController storyController, required int index}) {
//     final pageIndex = storyController.page ?? 0;
//     final progress = (pageIndex - index).abs().clamp(0.0, 1.0);
//     return 1 - progress;
//   }
// }

// class StoryItem extends StatefulWidget {
//   const StoryItem({
//     Key? key,
//     required this.image,
//     required this.storyItemController,
//     required this.masterPageController,
//     required this.maxStoryItem,
//     required this.currentStoryItem,
//     required this.maxPages,
//     required this.currentPage,
//   }) : super(key: key);

//   final StoryItemData image;
//   final PageController storyItemController;
//   final PageController masterPageController;
//   final int maxStoryItem;
//   final int currentStoryItem;
//   final int maxPages;
//   final int currentPage;

//   @override
//   State<StoryItem> createState() => _StoryItemState();
// }

// class _StoryItemState extends State<StoryItem> {
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     int duration = getDuration(widget.image);
//     debugPrint('duration: $duration');
//     _startTimer(duration);
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         (widget.image.isVideo)
//             ? Positioned.fill(
//                 child: VideoPlayerWidget(
//                   videoUrl: widget.image.url,
//                   gestureEnabled: true,
//                   playSound: true,
//                 ),
//               )
//             : Positioned.fill(
//                 child: ExtendedImage.network(
//                   widget.image.url,
//                   fit: BoxFit.cover,
//                   cache: true,
//                   loadStateChanged: (state) {
//                     if (state.extendedImageLoadState == LoadState.loading) {
//                       return const Center(
//                         child: CupertinoActivityIndicator(),
//                       );
//                     } else if (state.extendedImageLoadState ==
//                         LoadState.failed) {
//                       return const Center(
//                         child: Text('Failed to load image.'),
//                       );
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),
//               ),
//         // left half of the screen to go back
//         Positioned.fill(
//           left: 0,
//           right: MediaQuery.of(context).size.width / 2,
//           child: GestureDetector(
//             onTap: () {
//               _timer.cancel();
//               if (widget.currentStoryItem == 0) {
//                 if (widget.currentPage == 0) {
//                   Navigator.pop(context);
//                 } else {
//                   widget.masterPageController.previousPage(
//                     duration: const Duration(milliseconds: 400),
//                     curve: Curves.easeInOut,
//                   );
//                 }
//               } else {
//                 widget.storyItemController.previousPage(
//                   duration: const Duration(milliseconds: 400),
//                   curve: Curves.easeInOut,
//                 );
//               }
//             },
//           ),
//         ),
//         // right half of the screen to go next
//         Positioned.fill(
//           right: 0,
//           left: MediaQuery.of(context).size.width / 2,
//           child: GestureDetector(
//             onTap: () {
//               _timer.cancel();
//               _navigateNext();
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   void _startTimer(int duration) {
//     _timer = Timer(Duration(seconds: duration), () {
//       _navigateNext();
//     });
//   }

//   void _navigateNext() {
//     if (widget.currentStoryItem == widget.maxStoryItem) {
//       if (widget.currentPage == widget.maxPages) {
//         Navigator.pop(context);
//       } else {
//         widget.masterPageController.nextPage(
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeInOut,
//         );
//       }
//     } else {
//       widget.storyItemController.nextPage(
//         duration: const Duration(milliseconds: 400),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
// }

// class LinearProgressIndicatorWidget extends StatelessWidget {
//   final double value;
//   final double maxValue;
//   const LinearProgressIndicatorWidget({
//     Key? key,
//     required this.value,
//     required this.maxValue,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LinearProgressIndicator(
//       value: value,
//       backgroundColor: Colors.black12,
//       minHeight: 3,
//       borderRadius: BorderRadius.circular(5),
//       valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.9)),
//     );
//   }
// }

// int getDuration(StoryItemData storyItemData) {
//   if (storyItemData.isVideo) {
//     return 30;
//   } else {
//     return 5;
//   }
// }

// class StoryItemData {
//   final String url;
//   final bool isVideo;

//   StoryItemData({required this.url, required this.isVideo});
// }
