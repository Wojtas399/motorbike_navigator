import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

enum _TextType {
  labelMedium,
  labelLarge,
  bodyMedium,
  titleMedium,
  titleLarge,
  headlineLarge,
}

abstract class _Text extends StatelessWidget {
  final String data;
  final _TextType textType;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  const _Text(
    this.data, {
    required this.textType,
    this.color,
    this.fontWeight,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.theme.textTheme;
    final textStyle = switch (textType) {
      _TextType.labelMedium => textTheme.labelMedium,
      _TextType.labelLarge => textTheme.labelLarge,
      _TextType.titleMedium => textTheme.titleMedium,
      _TextType.bodyMedium => textTheme.bodyMedium,
      _TextType.titleLarge => textTheme.titleLarge,
      _TextType.headlineLarge => textTheme.headlineLarge,
    };

    return Text(
      data,
      style: textStyle?.copyWith(
        color: color,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }
}

class LabelMedium extends _Text {
  const LabelMedium(
    super.data, {
    super.color,
    super.fontWeight,
  }) : super(textType: _TextType.labelMedium);
}

class LabelLarge extends _Text {
  const LabelLarge(
    super.data, {
    super.color,
  }) : super(textType: _TextType.labelLarge);
}

class BodyMedium extends _Text {
  const BodyMedium(
    super.data, {
    super.color,
    super.fontWeight,
    super.textAlign,
  }) : super(textType: _TextType.bodyMedium);
}

class TitleMedium extends _Text {
  const TitleMedium(
    super.data, {
    super.color,
    super.fontWeight,
  }) : super(textType: _TextType.titleMedium);
}

class TitleLarge extends _Text {
  const TitleLarge(
    super.data, {
    super.fontWeight,
    super.color,
    super.textAlign,
  }) : super(textType: _TextType.titleLarge);
}

class HeadlineLarge extends _Text {
  const HeadlineLarge(
    super.data, {
    super.fontWeight,
  }) : super(textType: _TextType.headlineLarge);
}
