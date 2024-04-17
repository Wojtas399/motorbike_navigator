import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';

class MapSearchBar extends StatefulWidget {
  const MapSearchBar({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();

  void _onTap() {
    context.read<MapCubit>().changeMode(MapMode.search);
  }

  void _onBackButtonPressed() {
    FocusScope.of(context).unfocus();
    _controller.clear();
    context.read<MapCubit>().changeMode(MapMode.map);
  }

  void _onSubmitted(String? query) {
    if (query != null) {
      context.read<MapCubit>().searchPlaceSuggestions(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isSearchMode = context.select(
      (MapCubit cubit) => cubit.state.mode.isSearch,
    );

    return SearchBar(
      controller: _controller,
      hintText: context.str.mapSearch,
      leading: IconButton(
        onPressed: isSearchMode ? _onBackButtonPressed : null,
        icon: Icon(
          isSearchMode ? Icons.arrow_back_ios_new : Icons.location_on,
          color: context.colorScheme.primary,
        ),
      ),
      onTap: _onTap,
      elevation: isSearchMode ? MaterialStateProperty.all(0) : null,
      side: isSearchMode
          ? MaterialStateProperty.all(
              BorderSide(
                color: context.colorScheme.outline,
                width: 1.0,
              ),
            )
          : null,
      onSubmitted: _onSubmitted,
    );
  }
}
