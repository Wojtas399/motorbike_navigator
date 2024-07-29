import 'package:flutter/material.dart';

import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import 'stats_date_range_selection.dart';
import 'stats_detailed_data.dart';
import 'stats_mileage_column_chart.dart';

class StatsContent extends StatelessWidget {
  const StatsContent({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(context.str.statsScreenTitle),
        ),
        body: const Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              StatsDateRangeSelection(),
              GapVertical24(),
              StatsMileageColumnChart(),
              GapVertical24(),
              StatsDetailedData(),
            ],
          ),
        ),
      );
}
