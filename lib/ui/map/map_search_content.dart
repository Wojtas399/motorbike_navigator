import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapSearchContent extends StatelessWidget {
  const MapSearchContent({super.key});

  void _onPlacePressed(String placeId, BuildContext context) {
    context.read<MapCubit>().loadPlaceDetails(placeId);
  }

  @override
  Widget build(BuildContext context) {
    final cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );
    final suggestedPlaces = context.select(
      (MapCubit cubit) => cubit.state.placeSuggestions,
    );

    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight + 48),
      child: Column(
        children: [
          if (cubitStatus.isLoading) const LinearProgressIndicator(),
          if (cubitStatus.isSuccess)
            ...?suggestedPlaces?.map(
              (place) => ListTile(
                title: Text(place.name),
                subtitle: Text(place.fullAddress ?? ''),
                onTap: () => _onPlacePressed(place.id, context),
              ),
            ),
        ],
      ),
    );
  }
}
