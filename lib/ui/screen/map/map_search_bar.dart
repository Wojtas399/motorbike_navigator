import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/place_suggestion.dart';
import '../../animation/fade_page_route_animation.dart';
import '../../cubit/map/map_cubit.dart';
import '../../cubit/map/map_state.dart';
import '../../extensions/context_extensions.dart';
import '../search_form/search_form.dart';

class MapSearchBar extends StatefulWidget {
  const MapSearchBar({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();

  void _onSearchQueryChanged(String searchQuery) {
    _controller.text = searchQuery;
  }

  Future<void> _onTap() async {
    _focusNode.unfocus();
    final PlaceSuggestion? placeSuggestion = await Navigator.of(context).push(
      FadePageRouteAnimation(
        page: SearchForm(
          query: context.read<MapCubit>().state.searchQuery,
        ),
      ),
    );
    if (placeSuggestion != null && mounted) {
      context.read<MapCubit>().loadPlaceDetails(
            placeId: placeSuggestion.id,
            placeName: placeSuggestion.name,
          );
    }
  }

  void _onClearButtonPressed() {
    context.read<MapCubit>().resetSelectedPlace();
  }

  @override
  Widget build(BuildContext context) => BlocListener<MapCubit, MapState>(
        listenWhen: (prevState, currState) =>
            prevState.searchQuery != currState.searchQuery,
        listener: (_, state) => _onSearchQueryChanged(state.searchQuery),
        child: BlocSelector<MapCubit, MapState, String>(
          selector: (state) => state.searchQuery,
          builder: (BuildContext context, String searchQuery) => SearchBar(
            controller: _controller,
            focusNode: _focusNode,
            hintText: context.str.mapSearch,
            textInputAction: TextInputAction.search,
            leading: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.location_on,
                color: context.colorScheme.primary,
              ),
            ),
            trailing: [
              if (searchQuery.isNotEmpty)
                IconButton(
                  onPressed: _onClearButtonPressed,
                  icon: const Icon(Icons.close),
                ),
            ],
            onTap: _onTap,
          ),
        ),
      );
}
