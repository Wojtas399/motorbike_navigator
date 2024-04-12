import 'package:flutter/material.dart';

enum _TextType { titleMedium }

abstract class _Text extends StatelessWidget {
  final String data;
  final _TextType textType;

  const _Text(this.data, {required this.textType});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = switch (textType) {
      _TextType.titleMedium => textTheme.titleMedium,
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
