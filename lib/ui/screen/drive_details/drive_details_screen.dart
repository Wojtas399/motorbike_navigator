import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../extensions/context_extensions.dart';
import '../../service/dialog_service.dart';
import 'component/drive_details_content.dart';
import 'cubit/drive_details_cubit.dart';
import 'cubit/drive_details_state.dart';

@RoutePage()
class DriveDetailsScreen extends StatelessWidget {
  final int driveId;

  const DriveDetailsScreen({
    super.key,
    required this.driveId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<DriveDetailsCubit>()..initialize(driveId),
        child: const _CubitStatusListener(
          child: DriveDetailsContent(),
        ),
      );
}

class _CubitStatusListener extends StatelessWidget {
  final Widget child;

  const _CubitStatusListener({
    required this.child,
  });

  void _onStatusChanged(BuildContext context, DriveDetailsStateStatus status) {
    final DialogService dialogService = getIt.get<DialogService>();
    if (status == DriveDetailsStateStatus.loading) {
      dialogService.showLoadingDialog();
    } else {
      dialogService.closeLoadingDialog();
      if (status == DriveDetailsStateStatus.newTitleSaved) {
        Navigator.pop(context);
        dialogService.showSnackbarMessage(
          context.str.driveDetailsSuccessfullySavedTitle,
        );
      } else if (status == DriveDetailsStateStatus.driveDeleted) {
        Navigator.pop(context);
        dialogService.showSnackbarMessage(
          context.str.driveDetailsSuccessfullyDeletedDrive,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<DriveDetailsCubit, DriveDetailsState>(
        listenWhen: (
          DriveDetailsState prevState,
          DriveDetailsState currState,
        ) =>
            prevState.status != currState.status,
        listener: (
          BuildContext context,
          DriveDetailsState state,
        ) =>
            _onStatusChanged(context, state.status),
        child: child,
      );
}
