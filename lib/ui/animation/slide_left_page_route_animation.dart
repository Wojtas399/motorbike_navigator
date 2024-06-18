import 'package:flutter/material.dart';

class SlideLeftPageRouteAnimation<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlideLeftPageRouteAnimation({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            final tween = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            );

            return SlideTransition(
              position: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ).drive(tween),
              child: child,
            );
          },
        );
}
