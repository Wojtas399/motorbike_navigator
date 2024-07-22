import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/map_point.dart';
import '../../../entity/place_suggestion.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/search_form_cubit.dart';

class SearchFormSuggestedPlaces extends StatelessWidget {
  const SearchFormSuggestedPlaces({super.key});

  @override
  Widget build(BuildContext context) {
    final suggestedPlaces = context.select(
      (SearchFormCubit cubit) => cubit.state.placeSuggestions,
    );

    return SingleChildScrollView(
      child: Column(
        children: [
          ...ListTile.divideTiles(
            color: context.colorScheme.outline.withOpacity(0.25),
            tiles: [
              if (suggestedPlaces == null || suggestedPlaces.isEmpty == true)
                const _UserLocationItem(),
              ...?suggestedPlaces?.map((place) => _SuggestedPlaceItem(place)),
            ],
          ),
        ],
      ),
    );
  }
}

class _UserLocationItem extends StatelessWidget {
  const _UserLocationItem();

  void _onPressed(BuildContext context) {
    Navigator.pop(context, const UserLocationPoint());
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(context.str.yourLocalization),
        leading: const Icon(Icons.near_me),
        onTap: () => _onPressed(context),
      );
}

class _SuggestedPlaceItem extends StatelessWidget {
  final PlaceSuggestion place;

  const _SuggestedPlaceItem(this.place);

  void _onPlacePressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(
      context,
      SelectedPlacePoint(
        id: place.id,
        name: place.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(place.name),
        subtitle: place.fullAddress != null ? Text(place.fullAddress!) : null,
        onTap: () => _onPlacePressed(context),
      );
}
