import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/drive.dart';
import '../../component/gap.dart';
import '../../component/map_component.dart';
import '../../component/text.dart';
import '../../config/app_router.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';
import '../../extensions/datetime_extensions.dart';
import '../../extensions/duration_extensions.dart';

class SavedDrivesDriveItem extends StatelessWidget {
  final Drive drive;

  const SavedDrivesDriveItem({
    super.key,
    required this.drive,
  });

  void _onPressed(BuildContext context) {
    context.pushRoute(
      RoutePreviewRoute(routeWaypoints: drive.waypoints),
    );
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _onPressed(context),
        child: Container(
          color: Colors.white,
          margin: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: _StartDateTime(
                  startDateTime: drive.startDateTime,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: _DriveData(
                  distanceInKm: drive.distanceInKm,
                  duration: drive.duration,
                  avgSpeedInKmPerH: drive.avgSpeedInKmPerH,
                ),
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

class _StartDateTime extends StatelessWidget {
  final DateTime startDateTime;

  const _StartDateTime({required this.startDateTime});

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TitleLarge(
            startDateTime.toUIDate(),
            fontWeight: FontWeight.bold,
          ),
          const GapHorizontal8(),
          BodyMedium(
            'godz. ${startDateTime.toUITime()}',
            color: context.colorScheme.outline,
          ),
        ],
      );
}

class _DriveData extends StatelessWidget {
  final double distanceInKm;
  final Duration duration;
  final double avgSpeedInKmPerH;

  const _DriveData({
    required this.distanceInKm,
    required this.duration,
    required this.avgSpeedInKmPerH,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          _ValueWithLabel(
            label: context.str.distance,
            value: '${distanceInKm.toStringAsFixed(2)} km',
          ),
          const GapHorizontal32(),
          _ValueWithLabel(
            label: context.str.duration,
            value: duration.toUIFormat(),
          ),
          const GapHorizontal32(),
          _ValueWithLabel(
            label: context.str.avgSpeed,
            value: '${avgSpeedInKmPerH.toStringAsFixed(2)} km/h',
          ),
        ],
      );
}

class _ValueWithLabel extends StatelessWidget {
  final String label;
  final String value;

  const _ValueWithLabel({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelMedium(
            label,
            color: context.colorScheme.outline,
          ),
          const GapVertical4(),
          BodyMedium(
            value,
            fontWeight: FontWeight.bold,
          ),
        ],
      );
}

class _RoutePreview extends StatelessWidget {
  final List<Coordinates> waypoints;
  final VoidCallback onTap;

  const _RoutePreview({
    required this.waypoints,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    CameraFit? cameraFit;
    if (waypoints.toSet().length >= 2) {
      cameraFit = CameraFit.bounds(
        bounds: LatLngBounds(
          waypoints.first.toLatLng(),
          waypoints.last.toLatLng(),
        ),
        padding: const EdgeInsets.all(64),
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
