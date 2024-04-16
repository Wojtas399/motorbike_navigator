import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider/place_suggestions_provider.dart';

class MapSearchContent extends ConsumerWidget {
  const MapSearchContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedPlacesAsyncVal = ref.watch(placeSuggestionsProvider);

    return Padding(
      padding: const EdgeInsets.only(top: kToolbarHeight + 48),
      child: Column(
        children: [
          if (suggestedPlacesAsyncVal.isLoading)
            const LinearProgressIndicator(),
          if (!suggestedPlacesAsyncVal.isLoading)
            ...?suggestedPlacesAsyncVal.value?.map(
              (place) => ListTile(
                title: Text(place.name),
                subtitle: Text(place.fullAddress ?? ''),
                onTap: () {
                  //TODO
                },
              ),
            ),
        ],
      ),
    );
  }
}
