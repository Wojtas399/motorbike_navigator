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
          speedInKmPerH: position.speed * 3.6,
        );
      }
    }
  }

  Stream<geolocator.Position> _getPositionStream() =>
      geolocator.Geolocator.getPositionStream(
        locationSettings: const geolocator.LocationSettings(
          accuracy: geolocator.LocationAccuracy.bestForNavigation,
        ),
      );

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
