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

  // ScrollPhysics? homeScrollPhysics = const NeverScrollableScrollPhysics();

  // void setHomeScrollPhysics(ScrollPhysics physics) {
  //   homeScrollPhysics = physics;
  //   notifyListeners();
  // }
}
