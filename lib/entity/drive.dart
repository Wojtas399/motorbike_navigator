import 'coordinates.dart';
import 'entity.dart';

class Drive extends Entity {
  final String userId;
  final DateTime startDateTime;
  final double distanceInKm;
  final Duration duration;
  final double avgSpeedInKmPerH;
  final List<Coordinates> waypoints;

  const Drive({
    required super.id,
    required this.userId,
    required this.startDateTime,
    required this.distanceInKm,
    required this.duration,
    required this.avgSpeedInKmPerH,
    required this.waypoints,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        startDateTime,
        distanceInKm,
        duration,
        avgSpeedInKmPerH,
        waypoints,
      ];
}
