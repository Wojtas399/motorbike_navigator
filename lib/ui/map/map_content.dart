import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../entity/coordinates.dart';
import '../../env.dart';
import '../component/gap.dart';
import '../component/text.dart';
import '../extensions/context_extensions.dart';
import '../extensions/coordinates_extensions.dart';
import '../route_form/map_route_content.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_selected_place_details.dart';

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

  void _onCubitStateChanged(MapState state) {
    if (state.centerLocation == state.userLocation) {
      _mapController.moveAndRotate(
        state.centerLocation.toLatLng(),
        13,
        0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MapCubit>().stream.listen(_onCubitStateChanged);
    final Coordinates centerLocation = context.select(
      (MapCubit cubit) => cubit.state.centerLocation,
    );
    final Coordinates? userLocation = context.select(
      (MapCubit cubit) => cubit.state.userLocation,
    );
    final Coordinates? selectedPlaceCoordinates = context.select(
      (MapCubit cubit) => cubit.state.selectedPlace?.coordinates,
    );

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: centerLocation.toLatLng(),
            keepAlive: true,
            onPositionChanged: (camera, _) =>
                _onCameraPositionChanged(camera, context),
          ),
          children: [
            TileLayer(urlTemplate: Env.mapboxTemplateUrl),
            MarkerLayer(
              markers: [
                if (userLocation != null)
                  Marker(
                    width: 20,
                    height: 20,
                    point: userLocation.toLatLng(),
                    child: Image.asset('assets/location_icon.png'),
                  ),
                if (selectedPlaceCoordinates != null)
                  Marker(
                    width: 70,
                    height: 70,
                    point: selectedPlaceCoordinates.toLatLng(),
                    child: Image.asset('assets/pin.png'),
                  ),
              ],
            ),
          ],
        ),
        const _ActionButtons(),
        if (selectedPlaceCoordinates != null)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MapSelectedPlaceDetails(),
          ),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons();

  void _onMoveBackToUserLocation(BuildContext context) {
    context.read<MapCubit>().moveBackToUserLocation();
  }

  void _onOpenRouteForm(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => const RouteForm(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool doesUserLocationExist = context.select(
      (MapCubit cubit) => cubit.state.userLocation != null,
    );

    return Positioned(
      bottom: 24,
      right: 24,
      child: Column(
        children: [
          if (doesUserLocationExist) ...[
            FloatingActionButton(
              onPressed: () => _onMoveBackToUserLocation(context),
              heroTag: null,
              child: const Icon(Icons.my_location),
            ),
            const SizedBox(height: 24),
          ],
          FloatingActionButton(
            onPressed: () => _onOpenRouteForm(context),
            heroTag: null,
            child: const Icon(Icons.directions),
          ),
        ],
      ),
    );
  }
}
