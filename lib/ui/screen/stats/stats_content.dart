import 'package:flutter/material.dart';

import 'stats_date_range_selection.dart';

class StatsContent extends StatelessWidget {
  const StatsContent({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Statystyki'),
        ),
        body: const Column(
          children: [
            StatsDateRangeSelection(),
          ],
        ),
      );
}
