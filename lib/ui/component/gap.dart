import 'package:flutter/material.dart';

abstract class _Gap extends StatelessWidget {
  final double vertical;

  const _Gap({this.vertical = 0});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: vertical,
      );
}

class GapVertical24 extends _Gap {
  const GapVertical24() : super(vertical: 24);
}

class GapVertical16 extends _Gap {
  const GapVertical16() : super(vertical: 16);
}

class GapVertical8 extends _Gap {
  const GapVertical8() : super(vertical: 8);
}
