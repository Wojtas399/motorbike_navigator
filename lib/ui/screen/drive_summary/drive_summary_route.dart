import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/user.dart' as user;
import '../../component/map_component.dart';
import '../../config/app_router.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/logged_user/logged_user_cubit.dart';
import '../../extensions/coordinates_extensions.dart';

class DriveSummaryRoute extends StatelessWidget {
  const DriveSummaryRoute({super.key});

  void _onTap(BuildContext context, Iterable<Coordinates> routeWaypoints) {
    context.pushRoute(RoutePreviewRoute(
      routeWaypoints: routeWaypoints,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<Coordinates> routeWaypoints =
        context.read<DriveCubit>().state.waypoints;
    final user.ThemeMode? themeMode = context.select(
      (LoggedUserCubit cubit) => cubit.state.themeMode,
    );
    CameraFit? cameraFit;
    if (routeWaypoints.toSet().length >= 2) {
      cameraFit = CameraFit.coordinates(
        coordinates: routeWaypoints
            .map((Coordinates waypoint) => waypoint.toLatLng())
            .toList(),
        padding: const EdgeInsets.all(48),
      );
    }

    return MapComponent(
      isDarkMode: themeMode == user.ThemeMode.dark,
      disableMovement: true,
      initialCenter: routeWaypoints.first,
      initialCameraFit: cameraFit,
      onTap: () => _onTap(context, routeWaypoints),
      routeWaypoints: routeWaypoints,
    );
  }
}
