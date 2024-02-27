import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

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
              child: StoryView(
                controller: StoryController(),
                storyItems: [
                  StoryItem.pageImage(
                    url: images[0],
                    controller: StoryController(),
                  ),
                  StoryItem.pageImage(
                    url: images[0],
                    controller: StoryController(),
                  ),
                  StoryItem.pageVideo(
                    videos[1],
                    controller: StoryController(),
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
