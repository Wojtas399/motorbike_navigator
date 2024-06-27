import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/duration_extensions.dart';

class DriveSummaryData extends StatelessWidget {
  const DriveSummaryData({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          LabelLarge(context.str.driveDistance),
          const GapVertical4(),
          const _Distance(),
          const GapVertical8(),
          const Divider(),
          const GapVertical8(),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      LabelLarge(context.str.driveDuration),
                      const GapVertical4(),
                      const _Duration(),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      LabelLarge(context.str.driveAvgSpeed),
                      const GapVertical4(),
                      const _AvgSpeed(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final Duration duration = context.select(
      (DriveCubit cubit) => cubit.state.duration,
    );

    return TitleLarge(duration.toUIFormat());
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double distanceInKm = context.select(
      (DriveCubit cubit) => cubit.state.distanceInKm,
    );

    return TitleLarge('${distanceInKm.toStringAsFixed(2)} km');
  }
}

class _AvgSpeed extends StatelessWidget {
  const _AvgSpeed();

  @override
  Widget build(BuildContext context) {
    final double avgSpeed = context.select(
      (DriveCubit cubit) => cubit.state.avgSpeedInKmPerH,
    );

    return TitleLarge('${avgSpeed.toStringAsFixed(2)} km/h');
  }
}
