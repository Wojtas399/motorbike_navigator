import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';

class DriveSummaryActions extends StatelessWidget {
  const DriveSummaryActions({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: _DeleteButton(),
            ),
            GapHorizontal16(),
            Expanded(
              child: _SaveButton(),
            ),
          ],
        ),
      );
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton();

  Future<void> _onPressed(BuildContext context) async {
    final bool deleteConfirmation =
        await _askForConfirmationToDeleteDrive(context);
    if (deleteConfirmation == true && context.mounted) {
      Navigator.pop(context);
      context.read<DriveCubit>().resetDrive();
    }
  }

  Future<bool> _askForConfirmationToDeleteDrive(
    BuildContext context,
  ) async =>
      await getIt.get<DialogService>().askForConfirmation(
            title: context.str.driveSummaryDeleteConfirmationTitle,
            message: context.str.driveSummaryDeleteConfirmationMessage,
          );

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: () => _onPressed(context),
        child: Text(context.str.delete),
      );
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  void _onPressed(BuildContext context) {
    context.read<DriveCubit>().saveDrive();
  }

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: () => _onPressed(context),
        child: Text(context.str.save),
      );
}
