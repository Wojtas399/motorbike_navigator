import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'ui/cubit/location/location_cubit.dart';
import 'ui/cubit/location/location_state.dart';
import 'ui/screen/map/cubit/map_cubit.dart';
import 'ui/service/dialog_service.dart';

class LocationStatusListener extends StatelessWidget {
  final Widget? child;

  const LocationStatusListener({
    super.key,
    required this.child,
  });

  void _onStateChanged(BuildContext context, LocationState? state) {
    final DialogService dialogService = getIt.get<DialogService>();
    final LocationCubit locationCubit = context.read<LocationCubit>();
    if (state is LocationStateOff) {
      dialogService.showLocationOffDialog(
        onOpenDeviceLocationSettings: locationCubit.openLocationSettings,
      );
    } else if (state is LocationStateAccessDenied) {
      dialogService.showLocationAccessDeniedDialog(
        onOpenDeviceLocationSettings: locationCubit.openLocationSettings,
        onRefresh: () {
          locationCubit.listenToLocationStatus();
          context.read<MapCubit>().initialize();
        },
      );
    } else {
      dialogService.closeDialogIfIsOpened();
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<LocationCubit, LocationState?>(
        listener: _onStateChanged,
        child: child,
      );
}
