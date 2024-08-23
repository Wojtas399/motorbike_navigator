import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/location_service.dart';
import 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final LocationService _locationService;

  LocationCubit(this._locationService) : super(const LocationStateOn());

  Future<void> listenToLocationStatus() async {
    final bool hasLocationPermission = await _locationService.hasPermission();
    if (hasLocationPermission) {
      _listenToLocationStatus();
    } else {
      emit(const LocationStateAccessDenied());
    }
  }

  Future<void> _listenToLocationStatus() async {
    final locationStatus$ = _locationService.getLocationStatus();
    await for (final locationStatus in locationStatus$) {
      emit(switch (locationStatus) {
        LocationStatus.on => const LocationStateOn(),
        LocationStatus.off => const LocationStateOff(),
      });
    }
  }
}
