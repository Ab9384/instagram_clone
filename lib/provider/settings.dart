import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool isDark = false;

  void setTheme(bool value) {
    isDark = value;
    notifyListeners();
  }

  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }

  int currentHomeScreenIndex = 0;

  void setCurrentHomeScreenIndex(int index) {
    currentHomeScreenIndex = index;
    notifyListeners();
  }
}
