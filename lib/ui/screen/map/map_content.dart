import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../entity/coordinates.dart';
import '../../../env.dart';
import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../cubit/map/map_cubit.dart';
import '../../cubit/map/map_state.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';
import 'map_drive_details.dart';
import 'map_marker_layer.dart';
import 'map_polyline_layer.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MapStatus cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isLoading ? const _LoadingIndicator() : const _Map();
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

class _Map extends StatefulWidget {
  const _Map();

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<_Map> {
  late final MapController _mapController;

  @override
  void initState() {
    _mapController = MapController();
    super.initState();
  }

  void _onCameraPositionChanged(MapCamera camera, BuildContext context) {
    context.read<MapCubit>().onCenterLocationChanged(Coordinates(
          camera.center.latitude,
          camera.center.longitude,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Coordinates? centerLocation =
        context.read<MapCubit>().state.centerLocation;
    final DriveStateStatus driveStatus = context.select(
      (DriveCubit cubit) => cubit.state.status,
    );

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: centerLocation?.toLatLng() ??
                const LatLng(52.23178179122954, 21.006002101026827),
            keepAlive: true,
            onPositionChanged: (camera, _) =>
                _onCameraPositionChanged(camera, context),
          ),
          children: [
            TileLayer(urlTemplate: Env.mapboxTemplateUrl),
            const MapPolylineLayer(),
            const MapMarkerLayer(),
          ],
        ),
        switch (driveStatus) {
          DriveStateStatus.initial => const Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: _StartRideButton(),
            ),
          DriveStateStatus.ongoing => const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MapDriveDetails(),
            ),
        }
      ],
    );
  }
}

class _StartRideButton extends StatelessWidget {
  const _StartRideButton();

  void _onPressed(BuildContext context) {
    context.read<DriveCubit>().startDrive();
  }

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.navigation),
        label: const Text('Rozpocznij jazdę'),
      );
}
