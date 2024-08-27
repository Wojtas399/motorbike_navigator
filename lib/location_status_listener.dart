import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'ui/cubit/location/location_cubit.dart';
import 'ui/cubit/location/location_state.dart';
import 'ui/service/dialog_service.dart';

class LocationStatusListener extends StatefulWidget {
  final Widget? child;

  const LocationStatusListener({
    super.key,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<LocationStatusListener> {
  bool _isDialogOpened = false;

  void _onStateChanged(LocationState? state) {
    final DialogService dialogService = getIt.get<DialogService>();
    final LocationCubit locationCubit = context.read<LocationCubit>();
    if (state is LocationStateOff) {
      setState(() {
        _isDialogOpened = true;
      });
      dialogService.showLocationOffDialog(
        onOpenDeviceLocationSettings: locationCubit.openLocationSettings,
      );
    } else if (state is LocationStateAccessDenied) {
      setState(() {
        _isDialogOpened = true;
      });
      dialogService.showLocationAccessDeniedDialog(
        onOpenDeviceLocationSettings: locationCubit.openLocationSettings,
        onRefresh: locationCubit.listenToLocationStatus,
      );
    } else if (_isDialogOpened) {
      dialogService.closeDialog();
    }
  }

  @override
  Widget build(_) => BlocListener<LocationCubit, LocationState?>(
        listener: (_, state) => _onStateChanged(state),
        child: widget.child,
      );
}
