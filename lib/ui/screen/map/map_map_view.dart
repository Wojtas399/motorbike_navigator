import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/settings.dart' as settings;
import '../../component/big_filled_button_component.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/settings/settings_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';
import '../../provider/map_tile_url_provider.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
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
                child: _ThemeModeButton(),
              ),
              Positioned(
                bottom: mapMode.isDrive ? 406 : 104,
                right: 24,
                child: const _FollowUserLocationButton(),
              ),
              if (mapMode.isBasic) ...[
                const Positioned(
                  left: 16,
                  top: 16,
                  child: _MenuButton(),
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

    return BlocListener<MapCubit, MapState>(
      listenWhen: _canEmitMapCubitChange,
      listener: (_, __) => _handleCenterLocationChange(),
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

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton();

  @override
  Widget build(BuildContext context) {
    final settings.ThemeMode? themeMode = context.select(
      (SettingsCubit cubit) => cubit.state?.themeMode,
    );

    return themeMode != null
        ? IconButton.filledTonal(
            icon: switch (themeMode) {
              settings.ThemeMode.light => const Icon(Icons.dark_mode),
              settings.ThemeMode.dark => const Icon(Icons.light_mode),
            },
            onPressed: context.read<SettingsCubit>().switchThemeMode,
          )
        : const CircularProgressIndicator();
  }
}

class _FollowUserLocationButton extends StatelessWidget {
  const _FollowUserLocationButton();

  void _onPressed(BuildContext context) {
    context.read<MapCubit>().followUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final MapFocusMode focusMode = context.select(
      (MapCubit cubit) => cubit.state.focusMode,
    );

    return FloatingActionButton(
      heroTag: null,
      onPressed: () => _onPressed(context),
      child: Icon(
        focusMode == MapFocusMode.followUserLocation
            ? Icons.near_me
            : Icons.near_me_outlined,
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        onPressed: Scaffold.of(context).openDrawer,
        icon: const Icon(Icons.menu),
      );
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
