import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/drive.dart';
import '../../../component/gap.dart';
import '../../../component/map_component.dart';
import '../../../config/app_router.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/coordinates_extensions.dart';
import 'saved_drives_drive_item_data.dart';
import 'saved_drives_drive_item_header.dart';

class SavedDrivesDriveItem extends StatelessWidget {
  final Drive drive;

  const SavedDrivesDriveItem({
    super.key,
    required this.drive,
  });

  void _onPressed(BuildContext context) {
    context.pushRoute(
      DriveDetailsRoute(driveId: drive.id),
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _onPressed(context),
        child: Container(
          color: context.colorScheme.surfaceContainerLowest,
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SavedDrivesDriveItemHeader(
                title: drive.title,
                startDateTime: drive.startDateTime,
              ),
              SavedDrivesDriveItemData(
                distanceInKm: drive.distanceInKm,
                duration: drive.duration,
                avgSpeedInKmPerH: drive.avgSpeedInKmPerH,
              ),
              _RoutePreview(
                waypoints: drive.waypoints,
                onTap: () => _onPressed(context),
              ),
              const GapVertical24(),
            ],
          ),
        ),
      );
}

class _RoutePreview extends StatelessWidget {
  final Iterable<Coordinates> waypoints;
  final VoidCallback onTap;

  const _RoutePreview({
    required this.waypoints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    CameraFit? cameraFit;
    if (waypoints.toSet().length >= 2) {
      cameraFit = CameraFit.coordinates(
        coordinates: waypoints
            .map((Coordinates waypoint) => waypoint.toLatLng())
            .toList(),
        padding: const EdgeInsets.all(48),
      );
    }

    return SizedBox(
      height: 300,
      child: MapComponent(
        disableMovement: true,
        initialCenter: waypoints.first,
        initialCameraFit: cameraFit,
        routeWaypoints: waypoints,
        onTap: onTap,
      ),
    );
  }
}
