import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/place_suggestion.dart';
import '../extensions/context_extensions.dart';
import '../map/cubit/map_cubit.dart';

class SearchFormSuggestedPlaces extends StatelessWidget {
  const SearchFormSuggestedPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestedPlaces = context.select(
      (MapCubit cubit) => cubit.state.placeSuggestions,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          ...ListTile.divideTiles(
            color: context.colorScheme.outline.withOpacity(0.25),
            tiles: [
              ...?suggestedPlaces?.map((place) => _SuggestedPlaceItem(place)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestedPlaceItem extends StatelessWidget {
  final PlaceSuggestion place;

  const _SuggestedPlaceItem(this.place);

  void _onPlacePressed(String placeId, BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<MapCubit>().loadPlaceDetails(placeId);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(place.name),
        subtitle: place.fullAddress != null ? Text(place.fullAddress!) : null,
        onTap: () => _onPlacePressed(place.id, context),
      );
}
