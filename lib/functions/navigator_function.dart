import 'package:flutter/material.dart';

class NavigatorFunctions {
  static void navigateTo(
    BuildContext context,
    Widget page,
  ) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ));
  }

  // navigate to and remove all previous routes
  static void navigateAndClearStack(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ),
        (Route<dynamic> route) => false);
  }

  // naviagte and push replacement
  static void navigateAndReplace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return page;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        ));
  }
}
