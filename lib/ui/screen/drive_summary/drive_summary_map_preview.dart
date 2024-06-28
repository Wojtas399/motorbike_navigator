import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../../env.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';

class DriveSummaryMapPreview extends StatelessWidget {
  const DriveSummaryMapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Coordinates> routeWaypoints =
        context.read<DriveCubit>().state.waypoints;
    CameraFit? cameraFit;
    if (routeWaypoints.toSet().length >= 2) {
      cameraFit = CameraFit.bounds(
        bounds: LatLngBounds(
          routeWaypoints.first.toLatLng(),
          routeWaypoints.last.toLatLng(),
        ),
        padding: const EdgeInsets.all(128),
      );
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: routeWaypoints.first.toLatLng(),
        initialCameraFit: cameraFit,
      ),
      children: [
        TileLayer(
          urlTemplate: Env.mapboxTemplateUrl,
        ),
        const _PolylineLayer(),
        const _MarkerLayer(),
      ],
    );
  }
}

class _PolylineLayer extends StatelessWidget {
  const _PolylineLayer();

  @override
  Widget build(BuildContext context) {
    final List<Coordinates> routeWaypoints =
        context.read<DriveCubit>().state.waypoints;

    return PolylineLayer(
      polylines: [
        if (routeWaypoints.length >= 2)
          Polyline(
            points: routeWaypoints.map((point) => point.toLatLng()).toList(),
            strokeWidth: 6,
            color: context.colorScheme.primary,
          )
      ],
    );
  }
}

class _MarkerLayer extends StatelessWidget {
  const _MarkerLayer();

  @override
  Widget build(BuildContext context) {
    final List<Coordinates> routeWaypoints =
        context.read<DriveCubit>().state.waypoints;

    return MarkerLayer(
      markers: [
        Marker(
          point: routeWaypoints.first.toLatLng(),
          child: const _StartRouteMarker(),
        ),
        Marker(
          point: routeWaypoints.last.toLatLng(),
          child: const _EndRouteMarker(),
        ),
      ],
    );
  }
}

class _StartRouteMarker extends StatelessWidget {
  const _StartRouteMarker();

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(0, -8),
        child: const Icon(
          Icons.location_on,
          color: Colors.blue,
        ),
      );
}

class _EndRouteMarker extends StatelessWidget {
  const _EndRouteMarker();

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(4, -8),
        child: const Icon(
          Icons.flag,
          color: Colors.red,
        ),
      );
}
