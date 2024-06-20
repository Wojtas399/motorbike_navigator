import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../extensions/coordinates_extensions.dart';
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
      ],
    );
  }
}
