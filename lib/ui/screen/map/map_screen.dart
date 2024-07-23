import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../entity/user.dart' as user;
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
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
        child: Stack(
          children: [
            const MapContent(),
            const Positioned(
              top: kToolbarHeight + 16,
              right: 16,
              child: _DarkModeButton(),
            ),
            if (mapMode.isBasic)
              const Positioned(
                left: 16,
                top: kToolbarHeight + 16,
                child: _MenuButton(),
              ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  void _onPressed(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.menu),
      );
}

class _DarkModeButton extends StatelessWidget {
  const _DarkModeButton();

  @override
  Widget build(BuildContext context) {
    final user.ThemeMode? themeMode = context.select(
      (LoggedUserCubit cubit) => cubit.state.themeMode,
    );

    return themeMode != null
        ? IconButton.filledTonal(
            icon: switch (themeMode) {
              user.ThemeMode.light => const Icon(Icons.dark_mode),
              user.ThemeMode.dark => const Icon(Icons.light_mode),
            },
            onPressed: context.read<LoggedUserCubit>().switchThemeMode,
          )
        : const CircularProgressIndicator();
  }
}
