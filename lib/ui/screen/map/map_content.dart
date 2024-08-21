import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/info_component.dart';
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
        child: switch (cubitStatus) {
          MapStateStatus.loading => const _LoadingIndicator(),
          MapStateStatus.completed => const MapMapView(),
          MapStateStatus.locationIsOff => const _LocationIsOffInfo(),
          MapStateStatus.locationAccessDenied =>
            const _LocationAccessDeniedInfo(),
        },
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TitleMedium(context.str.mapLoading),
              const GapVertical24(),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
}

class _LocationIsOffInfo extends StatelessWidget {
  const _LocationIsOffInfo();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Info(
          title: context.str.mapLocationIsOffTitle,
          message: context.str.mapLocationIsOffMessage,
        ),
      );
}

class _LocationAccessDeniedInfo extends StatelessWidget {
  const _LocationAccessDeniedInfo();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Info(
          title: context.str.mapLocationAccessDeniedTitle,
          message: context.str.mapLocationAccessDeniedMessage,
          child: FilledButton(
            onPressed: context.read<MapCubit>().refreshLocationPermission,
            child: Text(context.str.refresh),
          ),
        ),
      );
}
