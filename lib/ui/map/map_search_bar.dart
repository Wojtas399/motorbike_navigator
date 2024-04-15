import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorbike_navigator/ui/extensions/context_extensions.dart';
import 'package:motorbike_navigator/ui/map/provider/place_suggestions_provider.dart';

class MapSearchBar extends ConsumerWidget {
  final bool isInSearchMode;
  final VoidCallback onTap;
  final VoidCallback onBackButtonPressed;

  const MapSearchBar({
    super.key,
    required this.isInSearchMode,
    required this.onTap,
    required this.onBackButtonPressed,
  });

  void _onBackButtonPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    onBackButtonPressed();
  }

  void _onSubmitted(String? query, WidgetRef ref) {
    if (query != null) {
      ref.watch(placeSuggestionsProvider.notifier).search(query);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => SearchBar(
        hintText: context.str.mapSearch,
        leading: IconButton(
          onPressed:
              isInSearchMode ? () => _onBackButtonPressed(context) : null,
          icon: Icon(
            isInSearchMode ? Icons.arrow_back_ios_new : Icons.location_on,
            color: context.colorScheme.primary,
          ),
        ),
        onTap: onTap,
        elevation: isInSearchMode ? MaterialStateProperty.all(0) : null,
        side: isInSearchMode
            ? MaterialStateProperty.all(
                BorderSide(
                  color: context.colorScheme.outline,
                  width: 1.0,
                ),
              )
            : null,
        onSubmitted: (String? query) => _onSubmitted(query, ref),
      );
}
