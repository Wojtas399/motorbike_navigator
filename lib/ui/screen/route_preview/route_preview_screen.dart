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
      initialCameraFit = CameraFit.bounds(
        bounds: LatLngBounds(
          routeWaypoints.first.toLatLng(),
          routeWaypoints.last.toLatLng(),
        ),
        padding: const EdgeInsets.all(128),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: MapComponent(
        initialCenter: routeWaypoints.first,
        initialCameraFit: initialCameraFit,
        routeWaypoints: routeWaypoints,
      ),
    );
  }
}
