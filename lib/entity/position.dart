import 'package:equatable/equatable.dart';

import 'coordinates.dart';

class Position extends Equatable {
  final Coordinates coordinates;
  final double elevation;
  final double speedInKmPerH;

  const Position({
    required this.coordinates,
    required this.elevation,
    required this.speedInKmPerH,
  });

  @override
  List<Object?> get props => [
        coordinates,
        elevation,
        speedInKmPerH,
      ];
}
