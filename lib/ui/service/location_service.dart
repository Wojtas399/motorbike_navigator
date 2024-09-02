import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:mutex/mutex.dart';
import 'package:rxdart/rxdart.dart';

import '../../entity/coordinates.dart';
import '../../entity/position.dart' as position_entity;

enum LocationStatus { on, off }

@singleton
class LocationService {
  final m = Mutex();

  Stream<LocationStatus> getLocationStatus() async* {
    final bool isLocationOn = await Geolocator.isLocationServiceEnabled();
    yield isLocationOn ? LocationStatus.on : LocationStatus.off;
    final serviceStatus$ = Geolocator.getServiceStatusStream().map(
      (ServiceStatus status) => switch (status) {
        ServiceStatus.enabled => LocationStatus.on,
        ServiceStatus.disabled => LocationStatus.off,
      },
    );
    await for (final serviceStatus in serviceStatus$) {
      yield switch (serviceStatus) {
        LocationStatus.on => LocationStatus.on,
        LocationStatus.off => LocationStatus.off,
      };
    }
  }

  Future<bool> hasPermission() async {
    await m.acquire();
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return false;
      }
      return !(permission == LocationPermission.deniedForever);
    } finally {
      m.release();
    }
  }

  Stream<position_entity.Position?> getPosition() => _getPositionStream()
      .map<position_entity.Position?>(
        (Position position) => position_entity.Position(
          coordinates: Coordinates(position.latitude, position.longitude),
          altitude: position.altitude,
          speedInKmPerH: position.speed * 3.6,
        ),
      )
      .onErrorReturn(null);

  Stream<Position> _getPositionStream() {
    const int distanceFilter = 25;
    LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        intervalDuration: const Duration(seconds: 1),
        distanceFilter: distanceFilter,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: distanceFilter,
      );
    }
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }
}
