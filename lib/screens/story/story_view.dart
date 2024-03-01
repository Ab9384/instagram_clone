import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/story_model.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:instagram_clone/provider/story_data.dart';
import 'package:instagram_clone/screens/story/story_viewer.dart';
import 'package:provider/provider.dart';

class StoryViewScreen extends StatefulWidget {
  final int index;
  const StoryViewScreen({Key? key, required this.index}) : super(key: key);

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
    List<StoryModel> storiesList = Provider.of<AppData>(context, listen: false)
        .storiesList
        .sublist(widget.index);

    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            Provider.of<StoryData>(context, listen: false)
                .updateStoryPage(index);
            Provider.of<StoryData>(context, listen: false).cancelTimer();
          },
          itemCount:
              Provider.of<AppData>(context, listen: false).storiesList.length,
          itemBuilder: (context, index) {
            final progress = index - _currentPageValue;
            final rotationY = lerpDouble(0, 30, progress)!;
            const maxOpacity = 0.8;
            final opacity = lerpDouble(0, maxOpacity, progress.abs())!
                .clamp(0.0, maxOpacity);
            final isLeaving = progress <= 0;
            final isPaging = opacity != maxOpacity;
            final transform = Matrix4.identity();
            int currentPage = _currentPageValue.toInt();
            // if cureent page is being changed then use the next page
            if (isPaging) {
              currentPage = progress < 0 ? currentPage : currentPage + 1;
              Provider.of<StoryData>(context, listen: false)
                  .cancelTimer(); // cancel the timer
            }
            debugPrint("currentPage: $currentPage");

            transform.setEntry(3, 2, 0.003);
            transform.rotateY(-rotationY * (pi / 180.0));
            return Transform(
                alignment: progress <= 0
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                transform: transform,
                child: Stack(
                  children: [
                    StoryViewer(
                      story: storiesList[index],
                      storyPageController: _pageController,
                    ),
                    if (isPaging && !isLeaving)
                      Positioned.fill(
                        child: Opacity(
                          opacity: opacity,
                          child: const ColoredBox(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                  ],
                ));
          },
        ),
      ),
    );
  }
}
