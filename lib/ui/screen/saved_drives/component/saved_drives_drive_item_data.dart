import 'package:flutter/material.dart';

import '../../../component/gap.dart';
import '../../../component/text.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/double_extensions.dart';
import '../../../extensions/duration_extensions.dart';

class SavedDrivesDriveItemData extends StatelessWidget {
  final double distanceInKm;
  final Duration duration;
  final double avgSpeedInKmPerH;

  const SavedDrivesDriveItemData({
    super.key,
    required this.distanceInKm,
    required this.duration,
    required this.avgSpeedInKmPerH,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Row(
          children: [
            _ValueWithLabel(
              label: context.str.distance,
              value: distanceInKm.toDistanceFormat(),
            ),
            const GapHorizontal32(),
            _ValueWithLabel(
              label: context.str.duration,
              value: duration.toUIFormat(),
            ),
            const GapHorizontal32(),
            _ValueWithLabel(
              label: context.str.avgSpeed,
              value: avgSpeedInKmPerH.toSpeedFormat(),
            ),
          ],
        ),
      );
}

class _ValueWithLabel extends StatelessWidget {
  final String label;
  final String value;

  const _ValueWithLabel({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelMedium(
            label,
            fontWeight: FontWeight.w300,
          ),
          const GapVertical4(),
          BodyMedium(
            value,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
}
