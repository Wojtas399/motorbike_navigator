import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../entity/coordinates.dart';
import '../../env.dart';
import '../extensions/context_extensions.dart';
import '../extensions/coordinates_extensions.dart';

class MapComponent extends StatelessWidget {
  final Coordinates initialCenter;
  final List<Coordinates>? routeWaypoints;
  final CameraFit? initialCameraFit;
  final bool disableMovement;
  final VoidCallback? onTap;

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
              child: const _StartRouteMarker(),
            ),
            Marker(
              point: routeWaypoints!.last.toLatLng(),
              child: const _EndRouteMarker(),
            ),
          ],
        ],
      );
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
