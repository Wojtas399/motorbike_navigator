import 'coordinates.dart';
import 'entity.dart';

class Drive extends Entity {
  final double distanceInKm;
  final int durationInSeconds;
  final double avgSpeedInKmPerH;
  final List<Coordinates> waypoints;

  const Drive({
    required super.id,
    required this.distanceInKm,
    required this.durationInSeconds,
    required this.avgSpeedInKmPerH,
    required this.waypoints,
  });

  @override
  List<Object?> get props => [
        id,
        distanceInKm,
        durationInSeconds,
        avgSpeedInKmPerH,
        waypoints,
      ];
}
