import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_drawer.dart';
import 'map_drive_cubit_listener.dart';
import 'map_map_view.dart';
import 'map_mode_listener.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MapStateStatus cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );

    return Scaffold(
      drawer: mapMode.isBasic ? const MapDrawer() : null,
      body: MultiBlocListener(
        listeners: const [
          MapModeListener(),
          MapDriveCubitListener(),
        ],
        child: cubitStatus.isLoading
            ? const _LoadingIndicator()
            : cubitStatus.isLocationAccessDenied
                ? const _LocationAccessDeniedInfo()
                : const MapMapView(),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleMedium(context.str.mapLoading),
            const GapVertical24(),
            const CircularProgressIndicator(),
          ],
        ),
      );
}

class _LocationAccessDeniedInfo extends StatelessWidget {
  const _LocationAccessDeniedInfo();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleLarge(
                context.str.mapLocationAccessDeniedTitle,
                fontWeight: FontWeight.bold,
              ),
              const GapVertical8(),
              BodyMedium(
                context.str.mapLocationAccessDeniedMessage,
                color: context.colorScheme.outline,
              ),
              const GapVertical16(),
              FilledButton(
                onPressed: context.read<MapCubit>().refreshLocationPermission,
                child: Text(context.str.refresh),
              ),
            ],
          ),
        ),
      );
}
