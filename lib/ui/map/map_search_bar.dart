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
  bool _isClearButtonVisible = false;

  @override
  void initState() {
    _controller.addListener(_onControllerValueChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerValueChanged);
    super.dispose();
  }

  void _onControllerValueChanged() {
    if (_isClearButtonVisible && _controller.text.isEmpty) {
      setState(() {
        _isClearButtonVisible = false;
      });
    } else if (!_isClearButtonVisible && _controller.text.isNotEmpty) {
      setState(() {
        _isClearButtonVisible = true;
      });
    }
  }

  void _onTap() {
    context.read<MapCubit>().changeMode(MapMode.search);
  }

  void _onBackButtonPressed() {
    FocusScope.of(context).unfocus();
    context.read<MapCubit>().changeMode(MapMode.map);
  }

  void _onClearButtonPressed() {
    _controller.clear();
    context.read<MapCubit>().resetPlaceSuggestions();
  }

  void _onSubmitted(String? query) {
    if (query != null && query.isNotEmpty) {
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
      textInputAction: TextInputAction.search,
      leading: IconButton(
        onPressed: isSearchMode ? _onBackButtonPressed : null,
        icon: Icon(
          isSearchMode ? Icons.arrow_back_ios_new : Icons.location_on,
          color: context.colorScheme.primary,
        ),
      ),
      trailing: [
        if (_isClearButtonVisible)
          IconButton(
            onPressed: _onClearButtonPressed,
            icon: const Icon(Icons.close),
          ),
      ],
      onTap: _onTap,
      elevation: isSearchMode ? WidgetStateProperty.all(0) : null,
      side: isSearchMode
          ? WidgetStateProperty.all(
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
