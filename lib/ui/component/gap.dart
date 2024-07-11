import 'package:flutter/material.dart';

abstract class _Gap extends StatelessWidget {
  final double vertical;
  final double horizontal;

  const _Gap({
    this.vertical = 0,
    this.horizontal = 0,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: vertical,
        width: horizontal,
      );
}

class GapHorizontal4 extends _Gap {
  const GapHorizontal4() : super(horizontal: 4);
}

class GapHorizontal8 extends _Gap {
  const GapHorizontal8() : super(horizontal: 8);
}

class GapHorizontal16 extends _Gap {
  const GapHorizontal16() : super(horizontal: 16);
}

class GapHorizontal32 extends _Gap {
  const GapHorizontal32() : super(horizontal: 32);
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

class GapVertical4 extends _Gap {
  const GapVertical4() : super(vertical: 4);
}
