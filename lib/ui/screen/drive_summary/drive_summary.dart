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
              GapVertical24(),
              _DriveActions(),
            ],
          ),
        ),
      );
}

class _DriveActions extends StatelessWidget {
  const _DriveActions();

  void _onDelete(BuildContext context) {
    //TODO
  }

  void _onSave(BuildContext context) {
    //TODO
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _onDelete(context),
                child: Text(context.str.delete),
              ),
            ),
            const GapHorizontal16(),
            Expanded(
              child: FilledButton(
                onPressed: () => _onSave(context),
                child: Text(context.str.save),
              ),
            ),
          ],
        ),
      );
}
