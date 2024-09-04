import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../entity/coordinates.dart';
import '../../../cubit/map/map_cubit.dart';
import '../../../extensions/coordinates_extensions.dart';

class MapMarkerLayer extends StatelessWidget {
  const MapMarkerLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final Coordinates? userLocation = context.select(
      (MapCubit cubit) => cubit.state.userPosition?.coordinates,
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
            rotate: true,
          ),
      ],
    );
  }
}
