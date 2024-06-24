import 'package:flutter/material.dart';

enum _TextType {
  labelLarge,
  bodyMedium,
  titleMedium,
}

abstract class _Text extends StatelessWidget {
  final String data;
  final _TextType textType;
  final Color? color;

  const _Text(
    this.data, {
    required this.textType,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = switch (textType) {
      _TextType.labelLarge => textTheme.labelLarge,
      _TextType.titleMedium => textTheme.titleMedium,
      _TextType.bodyMedium => textTheme.bodyMedium,
    };

    return Text(
      data,
      style: textStyle?.copyWith(
        color: color,
      ),
    );
  }
}

class LabelLarge extends _Text {
  const LabelLarge(
    super.data, {
    super.color,
  }) : super(textType: _TextType.labelLarge);
}

class BodyMedium extends _Text {
  const BodyMedium(super.data) : super(textType: _TextType.bodyMedium);
}

class TitleMedium extends _Text {
  const TitleMedium(super.data) : super(textType: _TextType.titleMedium);
}
