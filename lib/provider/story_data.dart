import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/app_data.dart';
import 'package:provider/provider.dart';

class StoryData extends ChangeNotifier {
  Map<int, List<double>> progress = {};
  Timer? timer;
  int storyPage = 0;

  initProgress(Map<int, List<double>> p) {
    progress = p;
    debugPrint('currentPage: $p');
  }

  // update story page
  updateStoryPage(int page) {
    storyPage = page;
  }

  void updateProgress(
    int index,
    int storyPage,
    double durationInSeconds,
    Function moveToNextPage,
    bool isWidgetMounted,
    BuildContext context,
  ) {
    if (timer != null) timer?.cancel();
    debugPrint("updating $storyPage on index $index");
    const updateInterval =
        Duration(milliseconds: 50); // Adjust interval as needed
    final steps = (durationInSeconds * 1000) / updateInterval.inMilliseconds;
    final stepIncrement = 1.0 / steps;
    double currentProgress = 0.0;
    timer = Timer.periodic(updateInterval, (t) {
      // debugPrint('updateProgress Timer $currentProgress');
      progress[storyPage]![index] += stepIncrement;
      currentProgress += stepIncrement;
      if (currentProgress >= 1) {
        t.cancel(); // Cancel the timer when progress reaches 1
        progress[storyPage]![index] = 1;
        Provider.of<AppData>(context, listen: false)
            .storiesList[storyPage]
            .storyItems[index]
            .isViewed = true;
        moveToNextPage();
      }
      if (!isWidgetMounted) {
        t.cancel();
      }
      notifyListeners(); // Notify listeners every time progress is updated
    });
  }

  cancelTimer() {
    if (timer != null) timer?.cancel();
  }

  // pauseTimer
  pauseTimer() {
    if (timer != null) timer?.cancel();
  }

  // resumeTimer
  resumeTimer(index, int storyPage, double durationInSeconds,
      Function moveToNextPage, context) {
    // start timer from where it was paused by reading the progress[index]
    const updateInterval = Duration(milliseconds: 50);
    final steps = (durationInSeconds * 1000) / updateInterval.inMilliseconds;
    final stepIncrement = 1.0 / steps;
    double currentProgress = progress[storyPage]![index];
    timer = Timer.periodic(updateInterval, (t) {
      debugPrint('resumeTimer Timer $currentProgress');
      progress[storyPage]![index] += stepIncrement;

      currentProgress += stepIncrement;
      if (currentProgress >= 1) {
        progress[storyPage]![index] = 1;
        t.cancel(); // Cancel the timer when progress reaches 1
        Provider.of<AppData>(context, listen: false)
            .storiesList[storyPage]
            .storyItems[index]
            .isViewed = true;
        moveToNextPage();
      }
      notifyListeners(); // Notify listeners every time progress is updated
    });
  }

  // updateProgress manually
  updateProgressManually(int index, int storyPage, double progressValue) {
    print('updating progress manually for $storyPage on index $index');
    progress[storyPage]![index] = progressValue;
    notifyListeners();
  }
}
