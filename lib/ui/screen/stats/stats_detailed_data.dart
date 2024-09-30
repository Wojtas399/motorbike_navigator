import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/text.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/double_extensions.dart';
import '../../extensions/duration_extensions.dart';
import 'cubit/stats_cubit.dart';

class StatsDetailedData extends StatelessWidget {
  const StatsDetailedData({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _NumberOfDrives(),
        _Mileage(),
        _TotalDuration(),
      ],
    );
  }
}

class _NumberOfDrives extends StatelessWidget {
  const _NumberOfDrives();

  @override
  Widget build(BuildContext context) {
    final int? numberOfDrives = context.select(
      (StatsCubit cubit) => cubit.state.numberOfDrives,
    );

    return _ParameterWithValue(
      parameterName: context.str.statsNumberOfDrives,
      value: '$numberOfDrives',
    );
  }
}

class _Mileage extends StatelessWidget {
  const _Mileage();

  @override
  Widget build(BuildContext context) {
    final double? mileage = context.select(
      (StatsCubit cubit) => cubit.state.mileageInKm,
    );

    return _ParameterWithValue(
      parameterName: context.str.distance,
      value: '${mileage?.toDistanceFormat()}',
    );
  }
}

class _TotalDuration extends StatelessWidget {
  const _TotalDuration();

  @override
  Widget build(BuildContext context) {
    final Duration? totalDuration = context.select(
      (StatsCubit cubit) => cubit.state.totalDuration,
    );

    return _ParameterWithValue(
      parameterName: context.str.duration,
      value: '${totalDuration?.toUIFormat()}',
    );
  }
}

class _ParameterWithValue extends StatelessWidget {
  final String parameterName;
  final String value;

  const _ParameterWithValue({
    required this.parameterName,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LabelMedium(parameterName),
            BodyMedium(
              value,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      );
}
