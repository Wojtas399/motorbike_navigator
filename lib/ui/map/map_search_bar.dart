import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:motorbike_navigator/ui/extensions/context_extensions.dart';
import 'package:motorbike_navigator/ui/map/provider/place_suggestions_provider.dart';

class MapSearchBar extends ConsumerStatefulWidget {
  final bool isInSearchMode;
  final VoidCallback onTap;
  final VoidCallback onBackButtonPressed;

  const MapSearchBar({
    super.key,
    required this.isInSearchMode,
    required this.onTap,
    required this.onBackButtonPressed,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _onBackButtonPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    _controller.clear();
    widget.onBackButtonPressed();
  }

  void _onSubmitted(String? query, WidgetRef ref) {
    if (query != null) {
      ref.watch(placeSuggestionsProvider.notifier).search(query);
    }
  }

  @override
  Widget build(BuildContext context) => SearchBar(
        controller: _controller,
        hintText: context.str.mapSearch,
        leading: IconButton(
          onPressed: widget.isInSearchMode
              ? () => _onBackButtonPressed(context)
              : null,
          icon: Icon(
            widget.isInSearchMode
                ? Icons.arrow_back_ios_new
                : Icons.location_on,
            color: context.colorScheme.primary,
          ),
        ),
        onTap: widget.onTap,
        elevation: widget.isInSearchMode ? MaterialStateProperty.all(0) : null,
        side: widget.isInSearchMode
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
