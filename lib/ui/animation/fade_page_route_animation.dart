import 'package:flutter/material.dart';

class FadePageRouteAnimation<T> extends PageRouteBuilder<T> {
  final Widget page;

  FadePageRouteAnimation({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
