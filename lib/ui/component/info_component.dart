import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'gap.dart';
import 'text.dart';

class Info extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? child;

  const Info({
    super.key,
    required this.title,
    this.message,
    this.child,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleLarge(
                title,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const GapVertical8(),
                BodyMedium(
                  message!,
                  color: context.colorScheme.outline,
                  textAlign: TextAlign.center,
                ),
              ],
              if (child != null) ...[
                const GapVertical16(),
                child!,
              ],
            ],
          ),
        ),
      );
}
