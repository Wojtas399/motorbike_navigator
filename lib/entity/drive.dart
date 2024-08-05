import 'package:collection/collection.dart';

import 'coordinates.dart';
import 'entity.dart';
import 'position.dart';

class Drive extends Entity {
  final DateTime startDateTime;
  final double distanceInKm;
  final Duration duration;
  final List<Position> positions;

  const Drive({
    required super.id,
    required this.startDateTime,
    required this.distanceInKm,
    required this.duration,
    required this.positions,
  });

  Iterable<Coordinates> get waypoints =>
      positions.map((Position position) => position.coordinates);

  double get avgSpeedInKmPerH =>
      positions.map((Position position) => position.speedInKmPerH).average;

  @override
  List<Object?> get props => [
        id,
        startDateTime,
        distanceInKm,
        duration,
        positions,
      ];
}
