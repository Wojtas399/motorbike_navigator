import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../entity/coordinates.dart';
import '../../extensions/coordinates_extensions.dart';
import '../route_form/cubit/route_form_cubit.dart';
import 'cubit/map_cubit.dart';

class MapMarkerLayer extends StatelessWidget {
  const MapMarkerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final Coordinates? userLocation = context.select(
      (MapCubit cubit) => cubit.state.userLocation,
    );
    final Coordinates? selectedPlaceCoordinates = context.select(
      (MapCubit cubit) => cubit.state.selectedPlace?.coordinates,
    );
    final List<Coordinates>? routeWaypoints = context.select(
      (RouteFormCubit cubit) => cubit.state.route?.waypoints,
    );

    return MarkerLayer(
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
        if (routeWaypoints != null) ...[
          Marker(
            point: routeWaypoints.first.toLatLng(),
            child: Transform.translate(
              offset: const Offset(-4, -4),
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 36,
              ),
            ),
          ),
          Marker(
            point: routeWaypoints.last.toLatLng(),
            child: Transform.translate(
              offset: const Offset(-4, -12),
              child: Icon(
                MdiIcons.mapMarkerRadius,
                color: Colors.red,
                size: 36,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
