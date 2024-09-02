import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/map/map_cubit.dart';
import '../../cubit/map/map_state.dart';
import '../../extensions/context_extensions.dart';
import 'listener/map_drive_cubit_listener.dart';
import 'listener/map_mode_listener.dart';
import 'map_drawer.dart';
import 'map_map_view.dart';

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
            : const MapMapView(),
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
