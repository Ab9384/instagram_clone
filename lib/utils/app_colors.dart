import 'package:flutter/material.dart';

class AppColors {
  // Instagram light theme colors
  static const Color instagramLightBackground = Color(0xFFFAFAFA);
  static const Color instagramLightText = Color(0xFF000000);
  static const Color instagramLightAccent = Color(0xFFFFFFFF); // White accents
  static const Color instagramLightPrimary =
      Color(0xFF1FA1FF); // Instagram blue

  static Color instagramGrey = Colors.grey.shade400; // Custom dark accent

  ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: instagramLightBackground,
          accentColor: instagramLightAccent,
          primarySwatch: MaterialColor(
            instagramLightPrimary.value,
            <int, Color>{
              50: instagramLightPrimary.withOpacity(0.1),
              100: instagramLightPrimary.withOpacity(0.2),
              200: instagramLightPrimary.withOpacity(0.3),
              300: instagramLightPrimary.withOpacity(0.4),
              400: instagramLightPrimary.withOpacity(0.5),
              500: instagramLightPrimary.withOpacity(0.6),
              600: instagramLightPrimary.withOpacity(0.7),
              700: instagramLightPrimary.withOpacity(0.8),
              800: instagramLightPrimary.withOpacity(0.9),
              900: instagramLightPrimary.withOpacity(1),
            },
          ),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      );

// Instagram dark theme colors
  static const Color instagramDarkBackground = Color(0xFF000000);
  static const Color instagramDarkText = Color(0xFFFFFFFF);
  static const Color instagramDarkAccent =
      Color(0xFF585858); // Custom dark accent
  static const Color instagramDarkPrimary = Color(0xFF1FA1FF); // Instagram blue

  ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: instagramDarkBackground,
          accentColor: instagramDarkAccent,
          primarySwatch: MaterialColor(
            instagramDarkPrimary.value,
            <int, Color>{
              50: instagramDarkPrimary.withOpacity(0.1),
              100: instagramDarkPrimary.withOpacity(0.2),
              200: instagramDarkPrimary.withOpacity(0.3),
              300: instagramDarkPrimary.withOpacity(0.4),
              400: instagramDarkPrimary.withOpacity(0.5),
              500: instagramDarkPrimary.withOpacity(0.6),
              600: instagramDarkPrimary.withOpacity(0.7),
              700: instagramDarkPrimary.withOpacity(0.8),
              800: instagramDarkPrimary.withOpacity(0.9),
              900: instagramDarkPrimary.withOpacity(1),
            },
          ),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      );

  bool isDark = false;

  Color get background =>
      isDark ? instagramDarkBackground : instagramLightBackground;
  Color get text => isDark ? instagramDarkText : instagramLightText;
  Color get accent => isDark ? instagramDarkAccent : instagramLightAccent;
  Color get primary => isDark ? instagramDarkPrimary : instagramLightPrimary;

  static const Color greenColor = Color(0xFF48BD69);
  static const Color redColor = Color(0xFFE74C3C);

  static LinearGradient instaGradient = const LinearGradient(
    colors: [
      Colors.purpleAccent,
      Colors.pinkAccent,
      Colors.orangeAccent,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient sunriseSorbetGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.55, 1.0],
    colors: [
      Color(0xFFFF9A8B),
      Color(0xFFFF6A88),
      Color(0xFFFF99AC),
    ],
    transform:
        GradientRotation(90 * 3.1415927 / 180), // Convert degrees to radians
  );

  static LinearGradient lemonLimeSherbetGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF85FFBD),
      Color(0xFFFFFB7D),
    ],
    transform:
        GradientRotation(45 * 3.1415927 / 180), // Convert degrees to radians
  );
  static LinearGradient peachySunsetGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFFFBAB7E),
      Color(0xFFF7CE68),
    ],
    transform:
        GradientRotation(62 * 3.1415927 / 180), // Convert degrees to radians
  );
  static LinearGradient azureAquaGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFF0093E9),
      Color(0xFF80D0C7),
    ],
    transform:
        GradientRotation(160 * 3.1415927 / 180), // Convert degrees to radians
  );
  static LinearGradient auroraBorealisGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.46, 1.0],
    colors: [
      Color(0xFF4158D0),
      Color(0xFFC850C0),
      Color(0xFFFFCC70),
    ],
  );
  static Gradient goldenMeadowGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
    colors: [
      Color(0xFFF4D03F),
      Color(0xFF16A085),
    ],
    transform:
        GradientRotation(132 * 3.1415927 / 180), // Convert degrees to radians
  );
  static Gradient vividVioletGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      Color(0xFFFF3CAC),
      Color(0xFF784BA0),
      Color(0xFF2B86C5),
    ],
    transform:
        GradientRotation(225 * 3.1415927 / 180), // Convert degrees to radians
  );

  static List<Gradient> gradients = [
    instaGradient,
    sunriseSorbetGradient,
    // lemonLimeSherbetGradient,
    peachySunsetGradient,
    azureAquaGradient,
    auroraBorealisGradient,
    goldenMeadowGradient,
    vividVioletGradient,
  ];
}
