import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dependency_injection.dart';
import 'ui/cubit/location/location_cubit.dart';
import 'ui/cubit/location/location_state.dart';
import 'ui/service/dialog_service.dart';

class RouteLocationObserver extends AutoRouteObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    final BuildContext? context = route.navigator?.context;
    if (context != null && route is PageRoute) {
      final LocationCubit locationCubit = context.read<LocationCubit>();
      final LocationState? locationState = locationCubit.state;
      final DialogService dialogService = getIt.get<DialogService>();
      if (locationState is LocationStateOff) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => dialogService.showLocationOffDialog(
            onOpenDeviceLocationSettings: locationCubit.openLocationSettings,
          ),
        );
      } else if (locationState is LocationStateAccessDenied) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => dialogService.showLocationAccessDeniedDialog(
            onOpenDeviceLocationSettings: locationCubit.openLocationSettings,
            onRefresh: locationCubit.listenToLocationStatus,
          ),
        );
      }
    }
    super.didPush(route, previousRoute);
  }
}
