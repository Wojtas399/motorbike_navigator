import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../animation/fade_page_route_animation.dart';
import '../../extensions/context_extensions.dart';
import '../search_form/search_form.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

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

  void _onTap() {
    _focusNode.unfocus();
    Navigator.of(context).push(
      FadePageRouteAnimation(
        page: BlocProvider.value(
          value: context.read<MapCubit>(),
          child: const SearchForm(),
        ),
      ),
    );
  }

  void _onClearButtonPressed() {
    context.read<MapCubit>().resetPlaceSuggestions();
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
