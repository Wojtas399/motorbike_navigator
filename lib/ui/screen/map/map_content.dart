import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../cubit/logged_user/logged_user_state.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/map_state.dart';
import 'map_drive_details.dart';
import 'map_map_view.dart';

class MapContent extends StatelessWidget {
  const MapContent({super.key});

  @override
  Widget build(BuildContext context) {
    final LoggedUserState loggedUserState = context.select(
      (LoggedUserCubit cubit) => cubit.state,
    );
    final MapStatus cubitStatus = context.select(
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
    final DriveStateStatus driveStatus = context.select(
      (DriveCubit cubit) => cubit.state.status,
    );

    return Stack(
      children: [
        const MapMapView(),
        if (driveStatus == DriveStateStatus.initial)
          const Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: _StartRideButton(),
          ),
        if (driveStatus == DriveStateStatus.ongoing)
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: MapDriveDetails(),
          ),
        Positioned(
          bottom: driveStatus == DriveStateStatus.ongoing ? 280 : 88,
          right: 24,
          child: const _FollowUserLocationButton(),
        ),
      ],
    );
  }
}

class _StartRideButton extends StatelessWidget {
  const _StartRideButton();

  void _onPressed(BuildContext context) {
    context.read<DriveCubit>().startDrive(
          startLocation: context.read<MapCubit>().state.userLocation,
        );
    context.read<MapCubit>().followUserLocation();
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
  Widget build(BuildContext context) => FloatingActionButton(
        onPressed: () => _onPressed(context),
        child: const Icon(Icons.near_me),
      );
}
