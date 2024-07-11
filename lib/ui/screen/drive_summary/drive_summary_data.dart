import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/datetime_extensions.dart';
import '../../extensions/duration_extensions.dart';

class DriveSummaryData extends StatelessWidget {
  const DriveSummaryData({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: _StartDateTime(),
          ),
          const GapVertical8(),
          Column(
            children: [
              LabelLarge(context.str.distance),
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
                          LabelLarge(context.str.duration),
                          const GapVertical4(),
                          const _Duration(),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: Column(
                        children: [
                          LabelLarge(context.str.avgSpeed),
                          const GapVertical4(),
                          const _AvgSpeed(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
}

class _StartDateTime extends StatelessWidget {
  const _StartDateTime();

  @override
  Widget build(BuildContext context) {
    final DateTime? startDateTime = context.select(
      (DriveCubit cubit) => cubit.state.startDatetime,
    );

    return LabelMedium(
      startDateTime == null ? '' : startDateTime.toUIDateWithTimeFormat(),
      color: context.colorScheme.outline,
    );
  }
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
