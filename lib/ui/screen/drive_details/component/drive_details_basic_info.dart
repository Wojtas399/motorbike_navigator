import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap.dart';
import '../../../component/text.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/duration_extensions.dart';
import '../cubit/drive_details_cubit.dart';

class DriveDetailsBasicInfo extends StatelessWidget {
  const DriveDetailsBasicInfo({super.key});

  @override
  Widget build(BuildContext context) => const IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _Distance(),
            ),
            VerticalDivider(),
            Expanded(
              child: _Duration(),
            ),
          ],
        ),
      );
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double? distanceInKm = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.distanceInKm,
    );

    return _LabelWithValue(
      label: context.str.distance,
      value: '${distanceInKm?.toStringAsFixed(2)} km',
    );
  }
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final Duration? duration = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.duration,
    );

    return _LabelWithValue(
      label: context.str.duration,
      value: '${duration?.toUIFormat()}',
    );
  }
}

class _LabelWithValue extends StatelessWidget {
  final String label;
  final String value;

  const _LabelWithValue({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          BodyMedium(
            label,
            fontWeight: FontWeight.w300,
          ),
          const GapVertical8(),
          TitleLarge(
            value,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
}
