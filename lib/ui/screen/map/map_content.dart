import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../../env.dart';
import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/map/map_cubit.dart';
import '../../cubit/map/map_state.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';
import '../route_form/route_form_popup.dart';
import 'map_marker_layer.dart';
import 'map_polyline_layer.dart';
import 'map_route_details.dart';
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

  void _onRouteCubitStateChanged(RouteState state) {
    if (state.route != null) {
      _adjustViewToRoute(
        state.route!.waypoints.first,
        state.route!.waypoints.last,
      );
    }
  }

  void _onMapCubitStateChanged(MapState state) {
    if (state.centerLocation == state.userLocation) {
      _adjustViewToPoint(state.centerLocation);
    }
  }

  void _adjustViewToRoute(Coordinates startLocation, Coordinates endLocation) {
    final bounds = LatLngBounds(
      startLocation.toLatLng(),
      endLocation.toLatLng(),
    );
    final cameraFit = CameraFit.bounds(
      bounds: bounds,
      padding: const EdgeInsets.fromLTRB(48, 256, 48, 48),
    );
    _mapController.moveAndRotate(bounds.center, 13, 0);
    _mapController.fitCamera(cameraFit);
  }

  void _adjustViewToPoint(Coordinates point) {
    _mapController.moveAndRotate(point.toLatLng(), 13, 0);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<MapCubit>().stream.listen(_onMapCubitStateChanged);
    context.watch<RouteCubit>().stream.listen(_onRouteCubitStateChanged);
    final MapMode mode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );
    final Coordinates centerLocation = context.select(
      (MapCubit cubit) => cubit.state.centerLocation,
    );
    final Coordinates? selectedPlaceCoordinates = context.select(
      (MapCubit cubit) => cubit.state.selectedPlace?.coordinates,
    );
    final List<Coordinates>? wayPoints = context.select(
      (RouteCubit cubit) => cubit.state.route?.waypoints,
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
            const MapPolylineLayer(),
            const MapMarkerLayer(),
          ],
        ),
        // if (mode == MapMode.preview)
        //   const Padding(
        //     padding: EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 0),
        //     child: MapSearchBar(),
        //   ),
        // if (mode == MapMode.preview) const MapActionButtons(),
        if (selectedPlaceCoordinates != null)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MapSelectedPlaceDetails(),
          ),
        if (mode == MapMode.routeSelection)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: RouteFormPopup(),
          ),
        if (mode == MapMode.routeSelection && wayPoints != null)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MapRouteDetails(),
          ),
        const Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: _StartRideButton(),
        ),
      ],
    );
  }
}

class _StartRideButton extends StatelessWidget {
  const _StartRideButton();

  void _onPressed() {
    //TODO
  }

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: _onPressed,
        icon: const Icon(Icons.navigation),
        label: const Text('Rozpocznij jazdę'),
      );
}
