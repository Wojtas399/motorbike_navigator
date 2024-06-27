import 'package:flutter/material.dart';

import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import 'drive_summary_data.dart';
import 'drive_summary_map_preview.dart';

class DriveSummary extends StatelessWidget {
  const DriveSummary({super.key});

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
                child: DriveSummaryMapPreview(),
              ),
              GapVertical24(),
              DriveSummaryData(),
            ],
          ),
        ),
      );
}
