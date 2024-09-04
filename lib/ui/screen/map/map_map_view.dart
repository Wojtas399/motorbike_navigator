import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../entity/coordinates.dart';
import '../../component/big_filled_button_component.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../cubit/map/map_cubit.dart';
import '../../cubit/map/map_state.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';
import '../../provider/map_tile_url_provider.dart';
import 'component/map_follow_user_location_button.dart';
import 'component/map_menu_button.dart';
import 'component/map_theme_mode_button.dart';
import 'map_marker_layer.dart';
import 'map_polyline_layer.dart';

class MapMapView extends StatelessWidget {
  const MapMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );

    return Stack(
      children: [
        const _Map(),
        SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 16,
                right: 16,
                child: MapThemeModeButton(),
              ),
              Positioned(
                bottom: mapMode.isDrive ? 426 : 104,
                right: 24,
                child: const MapFollowUserLocationButton(),
              ),
              if (mapMode.isBasic) ...[
                const Positioned(
                  left: 16,
                  top: 16,
                  child: MapMenuButton(),
                ),
                const Positioned(
                  bottom: 24,
                  left: 24,
                  right: 24,
                  child: _StartRideButton(),
                ),
              ],
            ],
          ),
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

class _StartRideButton extends StatelessWidget {
  const _StartRideButton();

  void _onPressed(BuildContext context) {
    final mapCubit = context.read<MapCubit>();
    final userPosition = context.read<MapCubit>().state.userPosition;
    context.read<DriveCubit>().startDrive(startPosition: userPosition);
    mapCubit.followUserLocation();
    mapCubit.changeMode(MapMode.drive);
  }

  @override
  Widget build(BuildContext context) => BigFilledButton(
        onPressed: () => _onPressed(context),
        icon: Icons.navigation,
        label: context.str.mapStartNavigation,
      );
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
