import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';

class MessageDialog extends StatelessWidget {
  final String title;
  final String message;

  const MessageDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: context.maybePop,
            child: Text(context.str.close),
          ),
        ],
      );
}
