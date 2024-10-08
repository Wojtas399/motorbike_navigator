import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/big_filled_button_with_icon.dart';
import '../../component/gap.dart';
import '../../cubit/drive/drive_cubit.dart';
import '../../cubit/map/map_cubit.dart';
import '../../cubit/map/map_state.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';

class DriveSummaryActions extends StatelessWidget {
  const DriveSummaryActions({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            _ResumeDriveButton(),
            GapVertical8(),
            Row(
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
          ],
        ),
      );
}

class _ResumeDriveButton extends StatelessWidget {
  const _ResumeDriveButton();

  void _onPressed(BuildContext context) {
    context.read<DriveCubit>().resumeDrive();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => BigFilledButtonWithIcon(
        onPressed: () => _onPressed(context),
        icon: Icons.play_arrow_outlined,
        label: context.str.driveSummaryResumeDrive,
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
      context.read<MapCubit>().changeMode(MapMode.basic);
    }
  }

  Future<bool> _askForConfirmationToDeleteDrive(
    BuildContext context,
  ) async =>
      await getIt.get<DialogService>().askForConfirmation(
            title: context.str.driveSummaryDeletionConfirmationTitle,
            message: context.str.driveSummaryDeletionConfirmationMessage,
          );

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: context.colorScheme.error,
        ),
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.delete_outline),
        label: Text(context.str.delete),
      );
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  void _onPressed(BuildContext context) {
    context.read<DriveCubit>().saveDrive();
  }

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.save_alt_outlined),
        label: Text(context.str.save),
      );
}
