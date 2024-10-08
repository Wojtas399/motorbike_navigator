import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../component/map_component.dart';
import '../../extensions/coordinates_extensions.dart';

@RoutePage()
class RoutePreviewScreen extends StatelessWidget {
  final Iterable<Coordinates> routeWaypoints;

  const RoutePreviewScreen({
    super.key,
    required this.routeWaypoints,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: const _CloseButton(),
        ),
        body: _Map(routeWaypoints: routeWaypoints),
      );
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filledTonal(
          onPressed: context.maybePop,
          icon: const Icon(Icons.close),
        ),
      );
}

class _Map extends StatelessWidget {
  final Iterable<Coordinates> routeWaypoints;

  const _Map({
    required this.routeWaypoints,
  });

  @override
  Widget build(BuildContext context) {
    CameraFit? initialCameraFit;
    if (routeWaypoints.toSet().length >= 2) {
      initialCameraFit = CameraFit.coordinates(
        coordinates: routeWaypoints
            .map((Coordinates waypoint) => waypoint.toLatLng())
            .toList(),
        padding: const EdgeInsets.all(64),
      );
    }

    return MapComponent(
      initialCenter: routeWaypoints.first,
      initialCameraFit: initialCameraFit,
      routeWaypoints: routeWaypoints,
    );
  }
}
