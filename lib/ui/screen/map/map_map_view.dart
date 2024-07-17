import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/user.dart' as user;
import '../../../env.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../extensions/coordinates_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
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

  void _onDragMap(LatLng newCenterPosition) {
    context.read<MapCubit>().onMapDrag(Coordinates(
          newCenterPosition.latitude,
          newCenterPosition.longitude,
        ));
  }

  void _moveCameraToPosition(Coordinates position) {
    if (context.read<MapCubit>().state.focusMode.isFollowingUserLocation) {
      final bool isInDriveMode =
          context.read<DriveCubit>().state.status.isOngoing;
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

  bool _canEmitMapCubitChange(MapState prevState, MapState currState) =>
      currState.focusMode.isFollowingUserLocation &&
      prevState.centerLocation != currState.centerLocation;

  bool _canEmitDriveCubitChange(DriveState prevState, DriveState currState) {
    final Function eq = const ListEquality().equals;
    return currState.waypoints.isNotEmpty == true &&
        !eq(prevState.waypoints, currState.waypoints);
  }

  @override
  Widget build(BuildContext context) {
    final Coordinates? initialCenterLocation =
        context.read<MapCubit>().state.centerLocation;

    return MultiBlocListener(
      listeners: [
        BlocListener<MapCubit, MapState>(
          listenWhen: _canEmitMapCubitChange,
          listener: (_, state) => _moveCameraToPosition(state.userLocation!),
        ),
        BlocListener<DriveCubit, DriveState>(
          listenWhen: _canEmitDriveCubitChange,
          listener: (_, state) => _moveCameraToPosition(state.waypoints.last),
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
    final user.ThemeMode? themeMode = context.select(
      (LoggedUserCubit cubit) => cubit.state.themeMode,
    );

    return TileLayer(
      urlTemplate: Env.mapboxTemplateUrl,
      tileBuilder:
          themeMode == user.ThemeMode.dark ? darkModeTileBuilder : null,
    );
  }
}
