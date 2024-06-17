import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import 'cubit/map_cubit.dart';
import 'map_content.dart';
import 'map_search_bar.dart';

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
  Widget build(BuildContext context) => const Stack(
        children: [
          MapContent(),
          Padding(
            padding: EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 0),
            child: MapSearchBar(),
          ),
        ],
      );
}
