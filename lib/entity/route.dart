import 'coordinates.dart';
import 'entity.dart';

class Route extends Entity {
  final double distanceInMeters;
  final List<Coordinates> waypoints;

  const Route({
    required super.id,
    required this.distanceInMeters,
    required this.waypoints,
  });

  @override
  List<Object?> get props => [
        id,
        distanceInMeters,
        waypoints,
      ];
}
