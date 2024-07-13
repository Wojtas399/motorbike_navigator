import 'package:equatable/equatable.dart';

import 'coordinates.dart';

class Position extends Equatable {
  final Coordinates coordinates;
  final double speedInKmPerH;

  const Position({
    required this.coordinates,
    required this.speedInKmPerH,
  });

  @override
  List<Object?> get props => [
        coordinates,
        speedInKmPerH,
      ];
}
