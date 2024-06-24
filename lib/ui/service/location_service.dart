import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';

@injectable
class LocationService {
  Stream<Coordinates?> getCurrentLocation() async* {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      yield null;
    } else {
      final position$ = _getPositionStream();
      await for (final position in position$) {
        yield Coordinates(position.latitude, position.longitude);
      }
    }
  }

  Stream<double> getCurrentSpeedInMetersPerHour() => _getPositionStream().map(
        (Position position) => position.speed,
      );

  Stream<Position> _getPositionStream() => Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    return !(permission == LocationPermission.deniedForever);
  }
}
