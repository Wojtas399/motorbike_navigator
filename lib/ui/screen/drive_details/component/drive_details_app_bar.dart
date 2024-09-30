import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/gap.dart';
import '../../../component/text.dart';
import '../../../extensions/context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/drive_details_cubit.dart';
import 'drive_details_new_title_dialog.dart';

class DriveDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const DriveDetailsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text(context.str.driveDetailsScreenTitle),
        actions: const [
          _PopupMenu(),
        ],
      );
}

enum _PopupMenuAction { editTitle, deleteDrive }

class _PopupMenu extends StatelessWidget {
  const _PopupMenu();

  void _onActionSelected(_PopupMenuAction action, BuildContext context) {
    switch (action) {
      case _PopupMenuAction.editTitle:
        _editTitle(context);
        break;
      case _PopupMenuAction.deleteDrive:
        _deleteDrive(context);
    }
  }

  Future<void> _editTitle(BuildContext context) async {
    await getIt.get<DialogService>().showFullScreenDialog(
          BlocProvider.value(
            value: context.read<DriveDetailsCubit>(),
            child: const DriveDetailsNewTitleDialog(),
          ),
        );
  }

  Future<void> _deleteDrive(BuildContext context) async {
    final bool canDelete = await _askForDeletionConfirmation(context);
    if (canDelete && context.mounted) {
      context.read<DriveDetailsCubit>().deleteDrive();
    }
  }

  Future<bool> _askForDeletionConfirmation(BuildContext context) async =>
      await getIt.get<DialogService>().askForConfirmation(
            title: context.str.driveDetailsDeletionConfirmationTitle,
            message: context.str.driveDetailsDeletionConfirmationMessage,
            confirmationButtonText: context.str.delete,
          );

  @override
  Widget build(BuildContext context) => PopupMenuButton<_PopupMenuAction>(
        itemBuilder: (_) => [
          _PopupMenuItem(
            value: _PopupMenuAction.editTitle,
            icon: Icons.edit_outlined,
            label: context.str.driveDetailsEditTitle,
          ),
          _PopupMenuItem(
            value: _PopupMenuAction.deleteDrive,
            icon: Icons.delete_outline,
            label: context.str.driveDetailsDeleteDrive,
            color: context.colorScheme.error,
          ),
        ],
        onSelected: (_PopupMenuAction action) =>
            _onActionSelected(action, context),
      );
}

class _PopupMenuItem<T> extends PopupMenuItem<T> {
  _PopupMenuItem({
    required super.value,
    required IconData icon,
    required String label,
    Color? color,
  }) : super(
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const GapHorizontal8(),
              BodyMedium(
                label,
                color: color,
              ),
            ],
          ),
        );
}
