import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/user.dart' as user;
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_map_view.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );

    return Stack(
      children: [
        const MapMapView(),
        const Positioned(
          top: kToolbarHeight + 16,
          right: 16,
          child: _DarkModeButton(),
        ),
        Positioned(
          bottom: mapMode.isDrive ? 420 : 88,
          right: 24,
          child: const _FollowUserLocationButton(),
        ),
        if (mapMode.isBasic) ...[
          const Positioned(
            left: 16,
            top: kToolbarHeight + 16,
            child: _MenuButton(),
          ),
          const Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _StartRideButton(),
          ),
        ]
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
        onPressed: Scaffold.of(context).openDrawer,
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

class _StartRideButton extends StatelessWidget {
  const _StartRideButton();

  void _onPressed(BuildContext context) {
    final mapCubit = context.read<MapCubit>();
    context.read<DriveCubit>().startDrive(
          startLocation: mapCubit.state.userLocation,
        );
    mapCubit.followUserLocation();
    mapCubit.changeMode(MapMode.drive);
  }

  @override
  Widget build(BuildContext context) => FilledButton.icon(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.navigation),
        label: Text(context.str.mapStartNavigation),
      );
}

class _FollowUserLocationButton extends StatelessWidget {
  const _FollowUserLocationButton();

  void _onPressed(BuildContext context) {
    context.read<MapCubit>().followUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    final MapFocusMode focusMode = context.select(
      (MapCubit cubit) => cubit.state.focusMode,
    );

    return FloatingActionButton(
      heroTag: null,
      onPressed: () => _onPressed(context),
      child: Icon(
        focusMode == MapFocusMode.followUserLocation
            ? Icons.near_me
            : Icons.near_me_outlined,
      ),
    );
  }
}
