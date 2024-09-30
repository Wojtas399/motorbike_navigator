import 'package:flutter/material.dart';

import '../../../component/gap.dart';
import '../../../component/text.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/datetime_extensions.dart';

class SavedDrivesDriveItemHeader extends StatelessWidget {
  final String title;
  final DateTime startDateTime;

  const SavedDrivesDriveItemHeader({
    super.key,
    required this.title,
    required this.startDateTime,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleLarge(
              title,
              fontWeight: FontWeight.bold,
            ),
            const GapVertical4(),
            BodyMedium(
              '${startDateTime.toUIDate()}, ${context.str.hourAbbr} ${startDateTime.toUITime()}',
              fontWeight: FontWeight.w300,
            ),
          ],
        ),
      );
}
