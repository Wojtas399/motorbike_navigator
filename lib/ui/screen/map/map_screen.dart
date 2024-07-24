import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../cubit/logged_user/logged_user_state.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_content.dart';
import 'map_drawer.dart';
import 'map_drive_cubit_listener.dart';
import 'map_mode_listener.dart';

@RoutePage()
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) => const _BlocProviders(
        child: _Content(),
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final LoggedUserState loggedUserState = context.select(
      (LoggedUserCubit cubit) => cubit.state,
    );
    final MapStateStatus cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );

    return Scaffold(
      drawer: mapMode.isBasic ? const MapDrawer() : null,
      body: MultiBlocListener(
        listeners: const [
          MapModeListener(),
          MapDriveCubitListener(),
        ],
        child: loggedUserState.status.isLoading || cubitStatus.isLoading
            ? const _LoadingIndicator()
            : const MapContent(),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleMedium(context.str.mapLoading),
            const GapVertical24(),
            const CircularProgressIndicator(),
          ],
        ),
      );
}
