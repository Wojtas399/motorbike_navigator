import 'package:collection/collection.dart';

import 'entity.dart';
import 'position.dart';

class Drive extends Entity {
  final String userId;
  final DateTime startDateTime;
  final double distanceInKm;
  final Duration duration;
  final List<Position> positions;

  const Drive({
    required super.id,
    required this.userId,
    required this.startDateTime,
    required this.distanceInKm,
    required this.duration,
    required this.positions,
  });

  double get avgSpeedInKmPerH =>
      positions.map((Position position) => position.speedInKmPerH).average;

  @override
  List<Object?> get props => [
        id,
        userId,
        startDateTime,
        distanceInKm,
        duration,
        positions,
      ];
}
