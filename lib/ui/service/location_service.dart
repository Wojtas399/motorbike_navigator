import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/position.dart' as position_entity;

@injectable
class LocationService {
  Future<bool> hasPermission() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    return !(permission == LocationPermission.deniedForever);
  }

  Stream<position_entity.Position> getPosition() async* {
    final position$ = _getPositionStream();
    await for (final position in position$) {
      yield position_entity.Position(
        coordinates: Coordinates(position.latitude, position.longitude),
        altitude: position.altitude,
        speedInKmPerH: position.speed * 3.6,
      );
    }
  }

  Future<Coordinates> loadLocation() async {
    final currentPosition = await Geolocator.getCurrentPosition();
    return Coordinates(
      currentPosition.latitude,
      currentPosition.longitude,
    );
  }

  Stream<Position> _getPositionStream() {
    LocationSettings locationSettings;
    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        intervalDuration: const Duration(seconds: 1),
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      );
    }
    return Geolocator.getPositionStream(
      locationSettings: locationSettings,
    );
  }
}
