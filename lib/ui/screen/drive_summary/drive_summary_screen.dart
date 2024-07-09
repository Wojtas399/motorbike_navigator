import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/drive/drive_state.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';
import 'drive_summary_data.dart';
import 'drive_summary_route.dart';

@RoutePage()
class DriveSummaryScreen extends StatelessWidget {
  const DriveSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) => _DriveCubitListener(
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.str.driveSummary),
          ),
          body: const SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: DriveSummaryRoute(),
                ),
                GapVertical24(),
                DriveSummaryData(),
                GapVertical24(),
                _DriveActions(),
              ],
            ),
          ),
        ),
      );
}

class _DriveCubitListener extends StatelessWidget {
  final Widget child;

  const _DriveCubitListener({required this.child});

  Future<void> _onStatusChanged(
    DriveStateStatus status,
    BuildContext context,
  ) async {
    final dialogService = getIt.get<DialogService>();
    if (status == DriveStateStatus.saving) {
      dialogService.showLoadingDialog();
    } else if (status == DriveStateStatus.saved) {
      dialogService.closeLoadingDialog();
      context.read<DriveCubit>().resetDrive();
      context.maybePop();
      dialogService.showSnackbarMessage(
        context.str.driveSuccessfullySavedDrive,
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocListener<DriveCubit, DriveState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (context, state) => _onStatusChanged(state.status, context),
        child: child,
      );
}

class _DriveActions extends StatelessWidget {
  const _DriveActions();

  Future<void> _onDelete(BuildContext context) async {
    final bool deleteConfirmation =
        await _askForConfirmationToDeleteDrive(context);
    if (deleteConfirmation == true && context.mounted) {
      await context.maybePop();
      if (context.mounted) context.read<DriveCubit>().resetDrive();
    }
  }

  void _onSave(BuildContext context) {
    context.read<DriveCubit>().saveDrive();
  }

  Future<bool> _askForConfirmationToDeleteDrive(
    BuildContext context,
  ) async =>
      await getIt.get<DialogService>().askForConfirmation(
            title: context.str.driveDeleteConfirmationTitle,
            message: context.str.driveDeleteConfirmationMessage,
          );

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
