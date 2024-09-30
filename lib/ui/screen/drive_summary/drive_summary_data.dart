import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/datetime_extensions.dart';
import '../../extensions/double_extensions.dart';
import '../../extensions/duration_extensions.dart';

class DriveSummaryData extends StatelessWidget {
  const DriveSummaryData({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: _StartDateTime(),
          ),
          GapVertical8(),
          Column(
            children: [
              _Distance(),
              Divider(height: 32),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: _Duration(),
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: _AvgSpeed(),
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
      startDateTime == null
          ? ''
          : '${startDateTime.toUIDate()}, ${startDateTime.toUITime()}',
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

    return _ValueWithLabel(
      label: context.str.duration,
      value: duration.toUIFormat(),
    );
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double distanceInKm = context.select(
      (DriveCubit cubit) => cubit.state.distanceInKm,
    );

    return _ValueWithLabel(
      label: context.str.distance,
      value: distanceInKm.toDistanceFormat(),
    );
  }
}

class _AvgSpeed extends StatelessWidget {
  const _AvgSpeed();

  @override
  Widget build(BuildContext context) {
    final double avgSpeed = context.select(
      (DriveCubit cubit) => cubit.state.avgSpeedInKmPerH,
    );

    return _ValueWithLabel(
      label: context.str.avgSpeed,
      value: avgSpeed.toSpeedFormat(),
    );
  }
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
        children: [
          LabelLarge(label),
          const GapVertical4(),
          TitleLarge(value),
        ],
      );
}
