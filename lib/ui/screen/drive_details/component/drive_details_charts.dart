import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../component/gap.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/double_extensions.dart';
import '../cubit/drive_details_cubit.dart';
import '../cubit/drive_details_state.dart';
import 'drive_details_chart.dart';

class DriveDetailsCharts extends StatelessWidget {
  const DriveDetailsCharts({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _SpeedChart(),
            GapVertical16(),
            _ElevationChart(),
          ],
        ),
      );
}

class _SpeedChart extends StatelessWidget {
  const _SpeedChart();

  @override
  Widget build(BuildContext context) {
    final List<DriveDetailsDistanceAreaChartData>? chartData = context.select(
      (DriveDetailsCubit cubit) => cubit.state.speedAreaChartData,
    );
    final double? avgSpeedInKmPerH = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.avgSpeedInKmPerH,
    );
    final double? maxSpeedInKmPerH = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.maxSpeedInKmPerH,
    );

    return DriveDetailsChart(
      title: context.str.speed,
      chart: SfCartesianChart(
        series: <CartesianSeries>[
          LineSeries<DriveDetailsDistanceAreaChartData, double>(
            dataSource: chartData,
            xValueMapper: (data, _) => data.distance,
            yValueMapper: (data, _) => data.value,
            color: context.colorScheme.primary,
          ),
        ],
      ),
      details: [
        DriveDetailsChartDetail(
          label: context.str.avgSpeed,
          value: '${avgSpeedInKmPerH?.toDistanceFormat()}',
        ),
        DriveDetailsChartDetail(
          label: context.str.driveDetailsMaxSpeed,
          value: '${maxSpeedInKmPerH?.toDistanceFormat()}',
        ),
      ],
    );
  }
}

class _ElevationChart extends StatelessWidget {
  const _ElevationChart();

  @override
  Widget build(BuildContext context) {
    final List<DriveDetailsDistanceAreaChartData>? chartData = context.select(
      (DriveDetailsCubit cubit) => cubit.state.elevationAreaChartData,
    );
    final double? maxElevation = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.maxElevation,
    );
    final double? minElevation = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.minElevation,
    );

    return DriveDetailsChart(
      title: context.str.elevation,
      chart: SfCartesianChart(
        series: <CartesianSeries>[
          AreaSeries<DriveDetailsDistanceAreaChartData, double>(
            dataSource: chartData,
            xValueMapper: (data, _) => data.distance,
            yValueMapper: (data, _) => data.value,
            color: context.colorScheme.tertiary,
          ),
        ],
      ),
      details: [
        DriveDetailsChartDetail(
          label: context.str.driveDetailsMaxElevation,
          value: '${maxElevation?.toElevationFormat()}',
        ),
        DriveDetailsChartDetail(
          label: context.str.driveDetailsMinElevation,
          value: '${minElevation?.toElevationFormat()}',
        ),
      ],
    );
  }
}
