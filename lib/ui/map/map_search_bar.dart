import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extensions/context_extensions.dart';
import '../search_form/search_form.dart';
import 'cubit/map_cubit.dart';

class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key});

  void _onTap(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) => BlocProvider.value(
          value: context.read<MapCubit>(),
          child: const SearchForm(),
        ),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  void _onClearButtonPressed(BuildContext context) {
    context.read<MapCubit>().resetPlaceSuggestions();
  }

  @override
  Widget build(BuildContext context) => SearchBar(
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
          IconButton(
            onPressed: () => _onClearButtonPressed(context),
            icon: const Icon(Icons.close),
          ),
        ],
        onTap: () => _onTap(context),
      );
}
