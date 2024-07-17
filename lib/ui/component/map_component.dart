import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../entity/coordinates.dart';
import '../../env.dart';
import '../extensions/context_extensions.dart';
import '../extensions/coordinates_extensions.dart';
import 'end_route_icon_component.dart';
import 'start_route_icon_component.dart';

class MapComponent extends StatelessWidget {
  final Coordinates initialCenter;
  final List<Coordinates>? routeWaypoints;
  final CameraFit? initialCameraFit;
  final bool disableMovement;
  final VoidCallback? onTap;
  final bool isDarkMode;

  const MapComponent({
    super.key,
    this.initialCenter = const Coordinates(
      52.232008819414474,
      21.00596281114088,
    ),
    this.routeWaypoints,
    this.initialCameraFit,
    this.disableMovement = false,
    this.onTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) => FlutterMap(
        options: MapOptions(
          interactionOptions: InteractionOptions(
            flags: disableMovement ? InteractiveFlag.none : InteractiveFlag.all,
          ),
          initialCenter: initialCenter.toLatLng(),
          initialCameraFit: initialCameraFit,
          onTap: (_, __) {
            if (onTap != null) onTap!();
          },
        ),
        children: [
          TileLayer(
            urlTemplate: Env.mapboxTemplateUrl,
            tileBuilder: isDarkMode ? darkModeTileBuilder : null,
          ),
          _PolylineLayer(
            routeWaypoints: routeWaypoints,
          ),
          _MarkerLayer(
            routeWaypoints: routeWaypoints,
          ),
        ],
      );
}

class _PolylineLayer extends StatelessWidget {
  final List<Coordinates>? routeWaypoints;

  const _PolylineLayer({
    this.routeWaypoints,
  });

  @override
  Widget build(BuildContext context) => PolylineLayer(
        polylines: [
          if (routeWaypoints != null && routeWaypoints!.length >= 2)
            Polyline(
              points: routeWaypoints!.map((point) => point.toLatLng()).toList(),
              strokeWidth: 6,
              color: context.colorScheme.primary,
            )
        ],
      );
}

class _MarkerLayer extends StatelessWidget {
  final List<Coordinates>? routeWaypoints;

  const _MarkerLayer({
    this.routeWaypoints,
  });

  @override
  Widget build(BuildContext context) => MarkerLayer(
        markers: [
          if (routeWaypoints?.isNotEmpty == true) ...[
            Marker(
              point: routeWaypoints!.first.toLatLng(),
              child: const StartRouteIcon(),
            ),
            Marker(
              point: routeWaypoints!.last.toLatLng(),
              child: const EndRouteIcon(),
            ),
          ],
        ],
      );
}
