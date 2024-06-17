import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../entity/coordinates.dart';
import '../../env.dart';
import '../component/gap.dart';
import '../component/text.dart';
import '../extensions/context_extensions.dart';
import '../extensions/coordinates_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

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

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: centerLocation.toLatLng(),
        keepAlive: true,
        onPositionChanged: (camera, _) =>
            _onCameraPositionChanged(camera, context),
      ),
      children: [
        TileLayer(
          urlTemplate: Env.mapboxTemplateUrl,
        ),
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
    );
  }
}
