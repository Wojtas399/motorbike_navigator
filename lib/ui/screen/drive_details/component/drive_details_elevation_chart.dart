import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../extensions/context_extensions.dart';
import '../../../extensions/double_extensions.dart';
import '../cubit/drive_details_cubit.dart';
import '../cubit/drive_details_state.dart';
import 'drive_details_chart.dart';

class DriveDetailsElevationChart extends StatelessWidget {
  const DriveDetailsElevationChart({super.key});

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
