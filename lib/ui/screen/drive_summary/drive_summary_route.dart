import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../component/map_component.dart';
import '../../config/app_router.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/coordinates_extensions.dart';

class DriveSummaryRoute extends StatelessWidget {
  const DriveSummaryRoute({super.key});

  void _onTap(BuildContext context) {
    context.pushRoute(RoutePreviewRoute(
      routeWaypoints: context.read<DriveCubit>().state.waypoints,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Coordinates> routeWaypoints =
        context.read<DriveCubit>().state.waypoints;
    CameraFit? cameraFit;
    if (routeWaypoints.toSet().length >= 2) {
      cameraFit = CameraFit.bounds(
        bounds: LatLngBounds(
          routeWaypoints.first.toLatLng(),
          routeWaypoints.last.toLatLng(),
        ),
        padding: const EdgeInsets.all(128),
      );
    }

    return MapComponent(
      disableMovement: true,
      initialCenter: routeWaypoints.first,
      initialCameraFit: cameraFit,
      onTap: () => _onTap(context),
      routeWaypoints: routeWaypoints,
    );
  }
}
