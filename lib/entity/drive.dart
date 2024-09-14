import 'package:collection/collection.dart';

import 'coordinates.dart';
import 'entity.dart';
import 'position.dart';

class Drive extends Entity {
  final String title;
  final DateTime startDateTime;
  final double distanceInKm;
  final Duration duration;
  final List<Position> positions;

  const Drive({
    required super.id,
    required this.title,
    required this.startDateTime,
    required this.distanceInKm,
    required this.duration,
    required this.positions,
  });

  Iterable<Coordinates> get waypoints => positions.map(
        (Position position) => position.coordinates,
      );

  Iterable<double> get elevationPoints => positions.map(
        (Position position) => position.elevation,
      );

  double get avgSpeedInKmPerH =>
      positions.map((Position position) => position.speedInKmPerH).average;

  double get maxSpeedInKmPerH =>
      positions.map((Position position) => position.speedInKmPerH).max;

  double get maxElevation =>
      positions.map((Position position) => position.elevation).max;

  double get minElevation =>
      positions.map((Position position) => position.elevation).min;

  @override
  List<Object?> get props => [
        id,
        title,
        startDateTime,
        distanceInKm,
        duration,
        positions,
      ];
}
