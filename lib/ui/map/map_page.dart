import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_content.dart';
import 'map_search_bar.dart';
import 'map_search_content.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<MapCubit>()..initialize(),
        child: const _Body(),
      );
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );

    return Stack(
      children: [
        switch (mapMode) {
          MapMode.map => const MapContent(),
          MapMode.search => const MapSearchContent(),
        },
        const Padding(
          padding: EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 0),
          child: MapSearchBar(),
        ),
      ],
    );
  }
}
