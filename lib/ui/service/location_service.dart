import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/position.dart';

@injectable
class LocationService {
  Stream<Position?> getPosition() async* {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      yield null;
    } else {
      final position$ = _getPositionStream();
      await for (final position in position$) {
        yield Position(
          coordinates: Coordinates(position.latitude, position.longitude),
          altitude: position.altitude,
          speedInKmPerH: position.speed * 3.6,
        );
      }
    }
  }

  Future<Coordinates?> loadLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;
    final currentPosition = await geolocator.Geolocator.getCurrentPosition();
    return Coordinates(
      currentPosition.latitude,
      currentPosition.longitude,
    );
  }

  Stream<geolocator.Position> _getPositionStream() {
    geolocator.LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = geolocator.AndroidSettings(
        intervalDuration: const Duration(seconds: 1),
      );
    } else {
      locationSettings = const geolocator.LocationSettings(
        accuracy: geolocator.LocationAccuracy.bestForNavigation,
      );
    }
    return geolocator.Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) return false;
    }
    return !(permission == geolocator.LocationPermission.deniedForever);
  }
}
