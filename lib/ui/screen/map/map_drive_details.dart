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
          children: [
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        LabelLarge('Czas'),
                        GapVertical4(),
                        _Duration(),
                        GapVertical8(),
                        Divider(),
                        GapVertical8(),
                        LabelLarge('Prędkość'),
                        GapVertical4(),
                        _Speed(),
                      ],
                    ),
                  ),
                  VerticalDivider(),
                  Expanded(
                    child: Column(
                      children: [
                        LabelLarge('Dystans'),
                        GapVertical4(),
                        _Distance(),
                        GapVertical8(),
                        Divider(),
                        GapVertical8(),
                        LabelLarge('Śr. prędkość'),
                        GapVertical4(),
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
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
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

class _Speed extends StatelessWidget {
  const _Speed();

  @override
  Widget build(BuildContext context) {
    final double speed = context.select(
      (DriveCubit cubit) => cubit.state.speedInKmPerH,
    );

    return TitleLarge('${speed.toStringAsFixed(2)} km/h');
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
