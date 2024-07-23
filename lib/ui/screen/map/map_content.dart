import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../cubit/logged_user/logged_user_state.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_map_view.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    final LoggedUserState loggedUserState = context.select(
      (LoggedUserCubit cubit) => cubit.state,
    );
    final MapStateStatus cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );

    return loggedUserState.status.isLoading || cubitStatus.isLoading
        ? const _LoadingIndicator()
        : const _Content();
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final MapMode mapMode = context.select(
      (MapCubit cubit) => cubit.state.mode,
    );

    return Stack(
      children: [
        const MapMapView(),
        if (mapMode.isBasic)
          const Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _StartRideButton(),
          ),
        Positioned(
          bottom: mapMode.isDrive ? 280 : 88,
          right: 24,
          child: const Column(
            children: [
              _FollowUserLocationButton(),
              GapVertical16(),
            ],
          ),
        ),
      ],
    );
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
