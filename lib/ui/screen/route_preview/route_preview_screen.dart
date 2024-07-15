import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../component/map_component.dart';
import '../../extensions/coordinates_extensions.dart';

@RoutePage()
class RoutePreviewScreen extends StatelessWidget {
  final List<Coordinates> routeWaypoints;

  const RoutePreviewScreen({
    super.key,
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const _CloseButton(),
      ),
      body: MapComponent(
        initialCenter: routeWaypoints.first,
        initialCameraFit: initialCameraFit,
        routeWaypoints: routeWaypoints,
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: IconButton.filled(
          onPressed: context.maybePop,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
          ),
        ),
      );
}
