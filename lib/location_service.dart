import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

@riverpod
LocationService locationService(LocationServiceRef ref) => LocationService();

class LocationService {
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

  Future<MapPosition?> getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return null;
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return MapPosition(position.longitude, position.latitude);
  }
}

class MapPosition extends Equatable {
  final double longitude;
  final double latitude;

  const MapPosition(this.longitude, this.latitude);

  @override
  List<Object?> get props => [longitude, latitude];
}
