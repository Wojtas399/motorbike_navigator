import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../service/device_settings_service.dart';
import '../../service/location_service.dart';
import 'location_state.dart';

@injectable
class LocationCubit extends Cubit<LocationState?> {
  final LocationService _locationService;
  final DeviceSettingsService _deviceSettingsService;

  LocationCubit(
    this._locationService,
    this._deviceSettingsService,
  ) : super(null);

  Future<void> listenToLocationStatus() async {
    final bool hasLocationPermission = await _locationService.hasPermission();
    if (hasLocationPermission) {
      _listenToLocationStatus();
    } else {
      emit(const LocationStateAccessDenied());
    }
  }

  void openLocationSettings() => _deviceSettingsService.openLocationSettings();

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
