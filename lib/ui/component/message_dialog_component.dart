import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;
  final List<Widget>? actions;

  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
    this.actions,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: actions ??
            [
              TextButton(
                onPressed: context.maybePop,
                child: Text(context.str.close),
              ),
            ],
      );
}
