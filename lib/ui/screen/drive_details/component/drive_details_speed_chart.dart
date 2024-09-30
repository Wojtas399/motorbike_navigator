import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../extensions/context_extensions.dart';
import '../../../extensions/double_extensions.dart';
import '../cubit/drive_details_cubit.dart';
import '../cubit/drive_details_state.dart';
import 'drive_details_chart.dart';

class DriveDetailsSpeedChart extends StatelessWidget {
  const DriveDetailsSpeedChart({super.key});

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
