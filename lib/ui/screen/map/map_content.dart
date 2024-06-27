import 'dart:async';

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

    return cubitStatus.isLoading ? const _LoadingIndicator() : const _Content();
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final DriveStateStatus driveStatus = context.select(
      (DriveCubit cubit) => cubit.state.status,
    );

    return Stack(
      children: [
        const _Map(),
        if (driveStatus == DriveStateStatus.initial)
          const Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _StartRideButton(),
          ),
        if (driveStatus == DriveStateStatus.ongoing)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MapDriveDetails(),
          ),
        Positioned(
          bottom: driveStatus == DriveStateStatus.ongoing ? 280 : 88,
          right: 24,
          child: const _FollowUserLocationButton(),
        ),
      ],
    );
  }
}

class _Map extends StatefulWidget {
  const _Map();

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<_Map> {
  late final MapController _mapController;
  StreamSubscription? _mapListener;

  @override
  void initState() {
    _mapController = MapController();
    _mapListener = _mapController.mapEventStream.listen(
      (MapEvent event) {
        if (event.source == MapEventSource.onDrag) {
          _onDragMap(event.camera.center);
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _mapListener?.cancel();
    super.dispose();
  }

  void _onDragMap(LatLng newCenterPosition) {
    context.read<MapCubit>().onMapDrag(Coordinates(
          newCenterPosition.latitude,
          newCenterPosition.longitude,
        ));
  }

  void _onUserPositionChanged(Coordinates position) {
    if (context.read<MapCubit>().state.focusMode ==
        MapFocusMode.followUserLocation) {
      final bool isInDriveMode =
          context.read<DriveCubit>().state.status == DriveStateStatus.ongoing;
      final double centerPositionLatCorrection = isInDriveMode ? -0.012 : 0;
      _mapController.move(
        LatLng(
          position.latitude + centerPositionLatCorrection,
          position.longitude,
        ),
        13,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Coordinates? centerLocation =
        context.read<MapCubit>().state.centerLocation;

    return MultiBlocListener(
      listeners: [
        BlocListener<MapCubit, MapState>(
          listenWhen: (prevState, currState) =>
              currState.userLocation != null &&
              currState.userLocation != prevState.userLocation,
          listener: (_, state) => _onUserPositionChanged(state.userLocation!),
        ),
        BlocListener<DriveCubit, DriveState>(
          listenWhen: (prevState, currState) =>
              currState.waypoints?.isNotEmpty == true,
          listener: (_, state) => _onUserPositionChanged(state.waypoints!.last),
        ),
      ],
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: centerLocation?.toLatLng() ??
              const LatLng(52.23178179122954, 21.006002101026827),
        ),
        children: [
          TileLayer(
            urlTemplate: Env.mapboxTemplateUrl,
          ),
          const MapPolylineLayer(),
          const MapMarkerLayer(),
        ],
      ),
    );
  }
}

class _FollowUserLocationButton extends StatelessWidget {
  const _FollowUserLocationButton();

  void _onPressed(BuildContext context) {
    context.read<MapCubit>().followUserLocation();
  }

  @override
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: () => _onPressed(context),
        child: const Icon(Icons.near_me),
      );
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
