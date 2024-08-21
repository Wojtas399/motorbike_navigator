import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../cubit/drive/drive_cubit.dart';
import 'cubit/map_cubit.dart';
import 'map_content.dart';

@RoutePage()
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) => const _BlocProviders(
        child: MapContent(),
      );
}

class _BlocProviders extends StatelessWidget {
  final Widget child;

  const _BlocProviders({required this.child});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt.get<MapCubit>()..initialize(),
          ),
          BlocProvider(
            create: (_) => getIt.get<DriveCubit>(),
          ),
        ],
        child: child,
      );
}
