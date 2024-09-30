import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../cubit/date_range/date_range_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/datetime_extensions.dart';
import 'cubit/stats_cubit.dart';
import 'cubit/stats_state.dart';

class StatsMileageColumnChart extends StatelessWidget {
  const StatsMileageColumnChart({super.key});

  String _createXValue(DateTime date, BuildContext context) {
    final DateRange? currentDateRange = context.read<DateRangeCubit>().state;
    return switch (currentDateRange) {
      null => '',
      WeeklyDateRange() => date.toDayAbbr(context),
      MonthlyDateRange() => date.toDay(),
      YearlyDateRange() => date.toMonthAbbr(context),
    };
  }

  @override
  Widget build(BuildContext context) {
    final List<MileageChartData>? mileageChartData = context.select(
      (StatsCubit cubit) => cubit.state.mileageChartData,
    );

    return SizedBox(
      height: 250,
      child: SfCartesianChart(
        primaryXAxis: const CategoryAxis(
          interval: 1,
        ),
        primaryYAxis: const NumericAxis(
          interval: 20,
        ),
        series: [
          ColumnSeries<MileageChartData, String>(
            animationDuration: 1000,
            color: context.colorScheme.primary,
            dataSource: mileageChartData,
            xValueMapper: (MileageChartData data, _) =>
                _createXValue(data.date, context),
            yValueMapper: (MileageChartData data, _) => data.value,
          ),
        ],
      ),
    );
  }
}
