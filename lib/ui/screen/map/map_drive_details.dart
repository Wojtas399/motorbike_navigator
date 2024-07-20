import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/duration_extensions.dart';

class MapDriveDetails extends StatelessWidget {
  const MapDriveDetails({super.key});

  @override
  Widget build(BuildContext context) => const _Body(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _Duration(),
                        Divider(height: 32),
                        _Speed(),
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: Column(
                      children: [
                        _Distance(),
                        Divider(height: 32),
                        _AvgSpeed(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            GapVertical24(),
            _PauseButton(),
          ],
        ),
      );
}

class _Body extends StatelessWidget {
  final Widget child;

  const _Body({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, -2),
              blurRadius: 20,
            ),
          ],
        ),
        child: child,
      );
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

class _Speed extends StatelessWidget {
  const _Speed();

  @override
  Widget build(BuildContext context) {
    final double speed = context.select(
      (DriveCubit cubit) => cubit.state.speedInKmPerH,
    );

    return _ValueWithLabel(
      label: context.str.speed,
      value: '${speed.toStringAsFixed(2)} km/h',
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
      value: '${distanceInKm.toStringAsFixed(2)} km',
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
      value: '${avgSpeed.toStringAsFixed(2)} km/h',
    );
  }
}

class _PauseButton extends StatelessWidget {
  const _PauseButton();

  void _onPressed(BuildContext context) {
    context.read<DriveCubit>().pauseDrive();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 300,
        child: FilledButton.icon(
          onPressed: () => _onPressed(context),
          icon: const Icon(Icons.stop_circle_outlined),
          label: Text(context.str.mapStopNavigation),
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
        children: [
          LabelLarge(label),
          const GapVertical4(),
          TitleLarge(value),
        ],
      );
}
