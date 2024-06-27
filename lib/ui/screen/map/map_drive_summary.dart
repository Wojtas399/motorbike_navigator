import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../entity/coordinates.dart';
import '../../../env.dart';
import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/coordinates_extensions.dart';
import '../../extensions/duration_extensions.dart';

class MapDriveSummary extends StatelessWidget {
  const MapDriveSummary({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.str.driveSummary),
        ),
        body: const SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 400,
                width: double.infinity,
                child: _MapPreview(),
              ),
              GapVertical24(),
              _DriveDetails(),
            ],
          ),
        ),
      );
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    final List<Coordinates>? route = context.read<DriveCubit>().state.waypoints;
    CameraFit? cameraFit;
    LatLng initialCenter = const LatLng(18, 50);
    if (route != null && route.length >= 2) {
      cameraFit = CameraFit.bounds(
        bounds: LatLngBounds(
          route.first.toLatLng(),
          route.last.toLatLng(),
        ),
        padding: const EdgeInsets.all(128),
      );
      initialCenter = route.first.toLatLng();
      // _mapController.fitCamera(cameraFit);
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialCameraFit: cameraFit,
      ),
      children: [
        TileLayer(
          urlTemplate: Env.mapboxTemplateUrl,
        ),
        PolylineLayer(
          polylines: [
            if (route != null)
              Polyline(
                points: route.map((point) => point.toLatLng()).toList(),
                strokeWidth: 6,
                color: context.colorScheme.primary,
              )
          ],
        ),
      ],
    );
  }
}

class _DriveDetails extends StatelessWidget {
  const _DriveDetails();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          LabelLarge(context.str.driveDistance),
          const GapVertical4(),
          const _Distance(),
          const GapVertical8(),
          const Divider(),
          const GapVertical8(),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      LabelLarge(context.str.driveDuration),
                      const GapVertical4(),
                      const _Duration(),
                    ],
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Column(
                    children: [
                      LabelLarge(context.str.driveAvgSpeed),
                      const GapVertical4(),
                      const _AvgSpeed(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _Duration extends StatelessWidget {
  const _Duration();

  @override
  Widget build(BuildContext context) {
    final Duration duration = context.select(
      (DriveCubit cubit) => cubit.state.duration,
    );

    return TitleLarge(duration.toUIFormat());
  }
}

class _Distance extends StatelessWidget {
  const _Distance();

  @override
  Widget build(BuildContext context) {
    final double distanceInKm = context.select(
      (DriveCubit cubit) => cubit.state.distanceInKm,
    );

    return TitleLarge('${distanceInKm.toStringAsFixed(2)} km');
  }
}

class _AvgSpeed extends StatelessWidget {
  const _AvgSpeed();

  @override
  Widget build(BuildContext context) {
    final double avgSpeed = context.select(
      (DriveCubit cubit) => cubit.state.avgSpeedInKmPerH,
    );

    return TitleLarge('${avgSpeed.toStringAsFixed(2)} km/h');
  }
}
