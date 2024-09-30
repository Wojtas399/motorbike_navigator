import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../entity/coordinates.dart';
import '../../../cubit/drive/drive_cubit.dart';
import '../../../cubit/drive/drive_state.dart';
import '../../../cubit/map/map_cubit.dart';
import '../../../cubit/map/map_state.dart';
import '../../../extensions/coordinates_extensions.dart';
import '../../../provider/map_tile_url_provider.dart';
import 'map_marker_layer.dart';
import 'map_polyline_layer.dart';

class MapMapView extends StatefulWidget {
  const MapMapView({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapMapView> {
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

  bool _hasFollowedCenterLocationChanged(
    MapState prevState,
    MapState currState,
  ) =>
      currState.focusMode.isFollowingUserLocation &&
      prevState.centerLocation != currState.centerLocation;

  bool _hasDriveStartedOrBeenSetAsInitial(
    DriveState prevState,
    DriveState currState,
  ) =>
      (currState.status == DriveStateStatus.ongoing ||
          currState.status == DriveStateStatus.initial) &&
      prevState.status != currState.status;

  void _onDragMap(LatLng newCenterPosition) {
    context.read<MapCubit>().onMapDrag(Coordinates(
          newCenterPosition.latitude,
          newCenterPosition.longitude,
        ));
  }

  void _adjustCenterLocationToCenterOfTheMap() {
    final state = context.read<MapCubit>().state;
    final userLocation = state.userPosition?.coordinates;
    final mapFocusMode = state.focusMode;
    if (userLocation != null && mapFocusMode.isFollowingUserLocation) {
      final double centerPositionLatCorrection =
          state.mode.isDrive ? -0.004 : 0;
      _mapController.move(
        LatLng(
          userLocation.latitude + centerPositionLatCorrection,
          userLocation.longitude,
        ),
        15,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Coordinates? initialCenterLocation =
        context.read<MapCubit>().state.centerLocation;

    return MultiBlocListener(
      listeners: [
        BlocListener<MapCubit, MapState>(
          listenWhen: _hasFollowedCenterLocationChanged,
          listener: (_, state) => _adjustCenterLocationToCenterOfTheMap(),
        ),
        BlocListener<DriveCubit, DriveState>(
          listenWhen: _hasDriveStartedOrBeenSetAsInitial,
          listener: (_, state) => _adjustCenterLocationToCenterOfTheMap(),
        ),
      ],
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: initialCenterLocation?.toLatLng() ??
              const LatLng(52.23178179122954, 21.006002101026827),
        ),
        children: const [
          _TileLayer(),
          MapPolylineLayer(),
          MapMarkerLayer(),
        ],
      ),
    );
  }
}

class _TileLayer extends StatelessWidget {
  const _TileLayer();

  @override
  Widget build(BuildContext context) {
    final String? tileUrl = context.select(
      (MapTileUrlProvider provider) => provider.state,
    );

    return tileUrl != null ? TileLayer(urlTemplate: tileUrl) : const SizedBox();
  }
}
