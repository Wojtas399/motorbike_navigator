import 'package:flutter/material.dart';

enum _TextType {
  titleMedium,
  bodyMedium,
}

abstract class _Text extends StatelessWidget {
  final String data;
  final _TextType textType;

  const _Text(this.data, {required this.textType});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = switch (textType) {
      _TextType.titleMedium => textTheme.titleMedium,
      _TextType.bodyMedium => textTheme.bodyMedium,
    };

    return Text(
      data,
      style: textStyle,
    );
  }
}

class TitleMedium extends _Text {
  const TitleMedium(super.data) : super(textType: _TextType.titleMedium);
}

class BodyMedium extends _Text {
  const BodyMedium(super.data) : super(textType: _TextType.bodyMedium);
}
