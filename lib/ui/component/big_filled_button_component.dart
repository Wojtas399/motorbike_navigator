import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'text.dart';

class BigFilledButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  const BigFilledButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 56,
        child: FilledButton.icon(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 32,
          ),
          label: TitleLarge(
            label,
            color: context.theme.canvasColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
