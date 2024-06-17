import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapSearchContent extends StatelessWidget {
  const MapSearchContent({super.key});

  void _onPlacePressed(String placeId, BuildContext context) {
    FocusScope.of(context).unfocus();
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

    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: kToolbarHeight + 48),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: context.colorScheme.outline,
              width: 0.4,
            ),
          ),
        ),
        child: cubitStatus.isLoading
            ? const LinearProgressIndicator()
            : cubitStatus.isSuccess
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        ...ListTile.divideTiles(
                          color: context.colorScheme.outline.withOpacity(0.25),
                          tiles: [
                            ...?suggestedPlaces?.map(
                              (place) => ListTile(
                                title: Text(place.name),
                                subtitle: place.fullAddress != null
                                    ? Text(place.fullAddress!)
                                    : null,
                                onTap: () => _onPlacePressed(place.id, context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : null,
      ),
    );
  }
}
