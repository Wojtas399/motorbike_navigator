import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'cubit/map_cubit.dart';
import 'cubit/navigation_cubit.dart';
import 'map_content.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<MapCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<NavigationCubit>(),
          ),
        ],
        child: const MapContent(),
      );
}
