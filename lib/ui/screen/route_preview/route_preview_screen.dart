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

  void _onCloseButtonPressed(BuildContext context) {
    context.maybePop();
  }

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
        leading: IconButton.filledTonal(
          onPressed: () => _onCloseButtonPressed(context),
          icon: const Icon(Icons.close),
        ),
      ),
      body: MapComponent(
        initialCenter: routeWaypoints.first,
        initialCameraFit: initialCameraFit,
        routeWaypoints: routeWaypoints,
      ),
    );
  }
}
