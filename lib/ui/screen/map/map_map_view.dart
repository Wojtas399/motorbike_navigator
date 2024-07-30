import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/user.dart' as user;
import '../../../env.dart';
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

  bool _canEmitMapCubitChange(MapState prevState, MapState currState) =>
      currState.focusMode.isFollowingUserLocation &&
      prevState.centerLocation != currState.centerLocation;

  void _onDragMap(LatLng newCenterPosition) {
    context.read<MapCubit>().onMapDrag(Coordinates(
          newCenterPosition.latitude,
          newCenterPosition.longitude,
        ));
  }

  void _handleCenterLocationChange() {
    final mapCubit = context.read<MapCubit>();
    final userLocation = mapCubit.state.userPosition?.coordinates;
    final mapFocusMode = mapCubit.state.focusMode;
    if (userLocation != null && mapFocusMode.isFollowingUserLocation) {
      final double centerPositionLatCorrection =
          mapCubit.state.mode.isDrive ? -0.024 : 0;
      _mapController.move(
        LatLng(
          userLocation.latitude + centerPositionLatCorrection,
          userLocation.longitude,
        ),
        13,
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
          listenWhen: _canEmitMapCubitChange,
          listener: (_, __) => _handleCenterLocationChange(),
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
