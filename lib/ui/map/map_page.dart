import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../../entity/coordinates.dart';
import '../../entity/place.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_content.dart';
import 'map_search_bar.dart';
import 'map_search_content.dart';
import 'map_selected_place_details.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<MapCubit>()..initialize(),
        child: const _Body(),
      );
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );
    final Coordinates? userLocation = context.select(
      (MapCubit cubit) => cubit.state.userLocation,
    );
    final Place? selectedPlace = context.select(
      (MapCubit cubit) => cubit.state.selectedPlace,
    );

    return Stack(
      children: [
        switch (mapMode) {
          MapMode.map => const MapContent(),
          MapMode.search => const MapSearchContent(),
        },
        const Padding(
          padding: EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 0),
          child: MapSearchBar(),
        ),
        if (userLocation != null)
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: context.read<MapCubit>().moveBackToUserLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        if (selectedPlace != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MapSelectedPlaceDetails(place: selectedPlace),
          ),
      ],
    );
  }
}
