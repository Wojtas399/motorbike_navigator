import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';
import 'cubit/map_cubit.dart';

class MapPolylineLayer extends StatelessWidget {
  const MapPolylineLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Coordinates>? waypoints = context.select(
      (MapCubit cubit) => cubit.state.wayPoints,
    );

    return PolylineLayer(
      polylines: [
        if (waypoints != null)
          Polyline(
            points: waypoints.map((point) => point.toLatLng()).toList(),
            strokeWidth: 6,
            color: context.colorScheme.primary,
          ),
      ],
    );
  }
}
