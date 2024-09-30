import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/drive.dart';
import '../../../component/map_component.dart';
import '../../../component/text.dart';
import '../../../config/app_router.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/coordinates_extensions.dart';
import '../cubit/drive_details_cubit.dart';

class DriveDetailsRoutePreview extends StatelessWidget {
  const DriveDetailsRoutePreview({super.key});

  void _onTap(BuildContext context) {
    final Drive? drive = context.read<DriveDetailsCubit>().state.drive;
    if (drive != null) {
      context.pushRoute(RoutePreviewRoute(
        routeWaypoints: drive.waypoints,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<Coordinates>? waypoints = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.waypoints,
    );
    CameraFit? cameraFit;
    if (waypoints != null && waypoints.toSet().length >= 2) {
      cameraFit = CameraFit.coordinates(
        coordinates: waypoints
            .map((Coordinates waypoint) => waypoint.toLatLng())
            .toList(),
        padding: const EdgeInsets.all(48),
      );
    }

    return Container(
      height: 300,
      width: double.infinity,
      color: context.colorScheme.outlineVariant,
      child: waypoints != null
          ? MapComponent(
              disableMovement: true,
              initialCenter: waypoints.first,
              initialCameraFit: cameraFit,
              routeWaypoints: waypoints,
              onTap: () => _onTap(context),
            )
          : const _RouteLoadErrorInfo(),
    );
  }
}

class _RouteLoadErrorInfo extends StatelessWidget {
  const _RouteLoadErrorInfo();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: TitleMedium(
            context.str.driveDetailsRouteLoadError,
            color: context.colorScheme.outline,
          ),
        ),
      );
}
