import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'text.dart';

class ConfirmationDialogComponent extends StatelessWidget {
  final String title;
  final String message;

  const ConfirmationDialogComponent({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(message),
        ),
        actions: [
          SizedBox(
            width: 120,
            child: OutlinedButton(
              onPressed: () => context.maybePop(false),
              child: LabelMedium(context.str.cancel),
            ),
          ),
          SizedBox(
            width: 120,
            child: FilledButton(
              onPressed: () => context.maybePop(true),
              child: Text(context.str.confirm),
            ),
          ),
        ],
      );
}
