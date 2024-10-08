import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

import '../../../../dependency_injection.dart';
import '../../../cubit/drive/drive_cubit.dart';
import '../../../cubit/drive/drive_state.dart';
import '../../../cubit/map/map_cubit.dart';
import '../../../cubit/map/map_state.dart';
import '../../../extensions/context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../../drive_summary/drive_summary_screen.dart';

class MapDriveCubitListener extends SingleChildStatelessWidget {
  const MapDriveCubitListener({super.key});

  void _onStatusChanged(DriveStateStatus status, BuildContext context) {
    switch (status) {
      case DriveStateStatus.paused:
        _handlePausedStatus(context);
      case DriveStateStatus.saving:
        _handleSavingStatus();
      case DriveStateStatus.saved:
        _handleSavedStatus(context);
      case _:
    }
  }

  void _handlePausedStatus(BuildContext context) {
    getIt.get<DialogService>().closeDialogIfIsOpened();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DriveSummaryScreen(),
      ),
    );
  }

  void _handleSavingStatus() {
    getIt.get<DialogService>().showLoadingDialog();
  }

  void _handleSavedStatus(BuildContext context) {
    final dialogService = getIt.get<DialogService>();
    dialogService.closeLoadingDialog();
    context.read<DriveCubit>().resetDrive();
    Navigator.pop(context);
    context.read<MapCubit>().changeMode(MapMode.basic);
    dialogService.showSnackbarMessage(
      context.str.driveSummarySuccessfullySavedDrive,
    );
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) =>
      BlocListener<DriveCubit, DriveState>(
        listenWhen: (prevState, currState) =>
            prevState.status != currState.status,
        listener: (BuildContext context, DriveState state) =>
            _onStatusChanged(state.status, context),
        child: child,
      );
}
