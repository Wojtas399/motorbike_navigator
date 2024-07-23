import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';

class MapPolylineLayer extends StatelessWidget {
  const MapPolylineLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Coordinates>? driveWaypoints = context.select(
      (DriveCubit cubit) => cubit.state.waypoints,
    );

    return PolylineLayer(
      polylines: [
        if (driveWaypoints != null)
          Polyline(
            points: driveWaypoints.map((point) => point.toLatLng()).toList(),
            strokeWidth: 6,
            color: context.colorScheme.primary,
          ),
      ],
    );
  }
}
