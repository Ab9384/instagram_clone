import 'dart:async';

import 'package:flutter/material.dart';

class StoryData extends ChangeNotifier {
  List<double> progress = [];
  Timer? timer;

  initProgress(int imageCount) {
    progress = List.generate(imageCount, (index) => 0.0);
  }

  void updateProgress(
    int index,
    int imageCount,
    double durationInSeconds,
    Function moveToNextPage,
    bool isWidgetMounted,
    BuildContext context,
  ) {
    const updateInterval =
        Duration(milliseconds: 50); // Adjust interval as needed
    final steps = (durationInSeconds * 1000) / updateInterval.inMilliseconds;
    final stepIncrement = 1.0 / steps;
    double currentProgress = 0.0;
    timer = Timer.periodic(updateInterval, (t) {
      print('updateProgress Timer $currentProgress');
      progress[index] += stepIncrement;

      currentProgress += stepIncrement;
      if (currentProgress >= 1) {
        t.cancel(); // Cancel the timer when progress reaches 1
        moveToNextPage();
      }
      if (!isWidgetMounted) {
        t.cancel();
      }
      notifyListeners(); // Notify listeners every time progress is updated
    });
  }

  canceTimer() {
    if (timer != null) timer?.cancel();
  }

  // pauseTimer
  pauseTimer() {
    if (timer != null) timer?.cancel();
  }

  // resumeTimer
  resumeTimer(index) {
    // start timer from where it was paused by reading the progress[index]
    const updateInterval = Duration(milliseconds: 50);
    final steps = (progress[index] * 1000) / updateInterval.inMilliseconds;
    final stepIncrement = 1.0 / steps;
    double currentProgress = progress[index];
    timer = Timer.periodic(updateInterval, (t) {
      print('resumeTimer Timer $currentProgress');
      progress[index] += stepIncrement;

      currentProgress += stepIncrement;
      if (currentProgress >= 1) {
        t.cancel(); // Cancel the timer when progress reaches 1
      }
      notifyListeners(); // Notify listeners every time progress is updated
    });
  }

  // updateProgress manually
  updateProgressManually(int index, double progressValue) {
    progress[index] = progressValue;
    notifyListeners();
  }
}
