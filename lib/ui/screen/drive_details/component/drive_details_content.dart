import 'package:flutter/material.dart';

import '../../../component/gap.dart';
import '../../../extensions/context_extensions.dart';
import 'drive_details_app_bar.dart';
import 'drive_details_basic_info.dart';
import 'drive_details_elevation_chart.dart';
import 'drive_details_header.dart';
import 'drive_details_route_preview.dart';
import 'drive_details_speed_chart.dart';

class DriveDetailsContent extends StatelessWidget {
  const DriveDetailsContent({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: DriveDetailsAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _FilledContainer(
                child: Column(
                  children: [
                    DriveDetailsHeader(),
                    GapVertical24(),
                    DriveDetailsBasicInfo(),
                    GapVertical24(),
                    DriveDetailsRoutePreview(),
                  ],
                ),
              ),
              GapVertical16(),
              _FilledContainer(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: DriveDetailsSpeedChart(),
                ),
              ),
              GapVertical16(),
              _FilledContainer(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: DriveDetailsElevationChart(),
                ),
              ),
              GapVertical16(),
            ],
          ),
        ),
      );
}

class _FilledContainer extends StatelessWidget {
  final Widget child;

  const _FilledContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
        color: context.colorScheme.surfaceContainerLowest,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: child,
      );
}
