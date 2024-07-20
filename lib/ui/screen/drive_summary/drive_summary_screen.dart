import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';
import 'drive_summary_actions.dart';
import 'drive_summary_data.dart';
import 'drive_summary_route.dart';

@RoutePage()
class DriveSummaryScreen extends StatelessWidget {
  const DriveSummaryScreen({super.key});

  Future<void> _onPop(
    bool didPop,
    BuildContext context,
  ) async {
    if (didPop) {
      return;
    }
    final NavigatorState navigator = Navigator.of(context);
    final bool canLeave = await _askForConfirmationToLeave(context);
    if (canLeave) {
      navigator.pop();
      if (context.mounted) context.read<DriveCubit>().resetDrive();
    }
  }

  Future<bool> _askForConfirmationToLeave(BuildContext context) async =>
      await getIt.get<DialogService>().askForConfirmation(
            title: context.str.driveSummaryLeaveConfirmationTitle,
            message: context.str.driveSummaryLeaveConfirmationMessage,
          );

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) => _onPop(didPop, context),
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.str.driveSummaryScreenTitle),
          ),
          body: const SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: DriveSummaryRoute(),
                ),
                GapVertical8(),
                DriveSummaryData(),
                GapVertical24(),
                DriveSummaryActions(),
              ],
            ),
          ),
        ),
      );
}
