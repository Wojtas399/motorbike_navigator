import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../component/end_route_icon_component.dart';
import '../../component/start_route_icon_component.dart';
import '../../cubit/route/route_cubit.dart';
import '../../extensions/coordinates_extensions.dart';
import 'cubit/map_cubit.dart';

class MapMarkerLayer extends StatelessWidget {
  const MapMarkerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final Coordinates? userLocation = context.select(
      (MapCubit cubit) => cubit.state.userLocation,
    );
    final List<Coordinates>? routeWaypoints = context.select(
      (RouteCubit cubit) => cubit.state.route?.waypoints,
    );

    return MarkerLayer(
      markers: [
        if (userLocation != null)
          Marker(
            width: 20,
            height: 20,
            point: userLocation.toLatLng(),
            child: Transform.translate(
              offset: const Offset(-1, -2),
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
            ),
          ),
        if (routeWaypoints?.isNotEmpty == true) ...[
          Marker(
            point: routeWaypoints!.first.toLatLng(),
            child: const StartRouteIcon(),
          ),
          Marker(
            point: routeWaypoints.last.toLatLng(),
            child: const EndRouteIcon(),
          ),
        ],
      ],
    );
  }
}
