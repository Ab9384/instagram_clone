import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/app_data.dart';
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
    List<String> selectedImages = [images[0], images[15]];
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: selectedImages.length,
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
              child: Stack(
                children: [
                  Positioned.fill(
                    child: StoryItemViewer(
                      selectedImages: selectedImages.sublist(0, 2),
                      masterPageController: _pageController,
                      maxPage: selectedImages.length - 1,
                      currentPage: index,
                    ),
                  ),
                  if (isPaging && progress > 0)
                    Positioned.fill(
                      child: Opacity(
                        opacity: opacity,
                        child: const ColoredBox(
                          color: Colors.black87,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class StoryItemViewer extends StatelessWidget {
  const StoryItemViewer({
    super.key,
    required this.selectedImages,
    required this.masterPageController,
    required this.maxPage,
    required this.currentPage,
  });

  final List<String> selectedImages;
  final PageController masterPageController;
  final int maxPage;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    final storyItemController =
        PageController(initialPage: 0, viewportFraction: 1.0);
    return PageView.builder(
      itemCount: selectedImages.length,
      controller: storyItemController,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Duration duration = const Duration(seconds: 5);

        return Stack(
          children: [
            Positioned.fill(
              child: StoryItem(
                image: selectedImages[index],
                storyItemController: storyItemController,
                masterPageController: masterPageController,
                maxStoryItem: selectedImages.length - 1,
                currentStoryItem: index,
                currentPage: currentPage,
                maxPages: maxPage,
              ),
            ),
            // progress bar for all stories in the list
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Row(
                children: List.generate(
                  selectedImages.length,
                  (indicatorIndex) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: LinearProgressIndicatorWidget(
                        value: getProgress(indicatorIndex, index),
                        maxValue: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  storyItemController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                  if (index == 0) {
                    masterPageController.previousPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }

                  if (currentPage == 0 && index == 0) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.transparent,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  storyItemController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                  if (index == selectedImages.length - 1) {
                    masterPageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }

                  if (currentPage == maxPage &&
                      index == selectedImages.length - 1) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  double getProgress(int indicatorIndex, int index) {
    print("indicatorIndex: $indicatorIndex, index: $index");
    if (indicatorIndex > index) {
      return 1.0;
    } else if (indicatorIndex < index) {
      return 0;
    } else {
      return 0.5;
    }
  }
}

class StoryItem extends StatefulWidget {
  const StoryItem({
    super.key,
    required this.image,
    required this.storyItemController,
    required this.masterPageController,
    required this.maxStoryItem,
    required this.currentStoryItem,
    required this.maxPages,
    required this.currentPage,
  });

  final String image;
  final PageController storyItemController;
  final PageController masterPageController;
  final int maxStoryItem;
  final int currentStoryItem;
  final int maxPages;
  final int currentPage;

  @override
  State<StoryItem> createState() => _StoryItemState();
}

class _StoryItemState extends State<StoryItem> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      widget.image,
      fit: BoxFit.cover,
      cache: true,
      loadStateChanged: (state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        } else if (state.extendedImageLoadState == LoadState.failed) {
          return const Center(
            child: Text(''),
          );
        } else {
          _timer = Timer(const Duration(seconds: 5), () {
            if (widget.currentStoryItem == widget.maxStoryItem) {
              if (widget.masterPageController.hasClients) {
                widget.masterPageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              }
              if (widget.currentPage == widget.maxPages) {
                Navigator.pop(context);
              }
            } else {
              widget.storyItemController.nextPage(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            }
          });
          return null;
        }
      },
    );
  }
}

class LinearProgressIndicatorWidget extends StatelessWidget {
  final double value;
  final double maxValue;
  const LinearProgressIndicatorWidget(
      {super.key, required this.value, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: 0.5,
      backgroundColor: Colors.black12,
      minHeight: 3,
      borderRadius: BorderRadius.circular(5),
      valueColor: AlwaysStoppedAnimation(Colors.white.withOpacity(0.9)),
    );
  }
}
