import 'package:equatable/equatable.dart';

import 'coordinates.dart';

class Position extends Equatable {
  final Coordinates coordinates;
  final double speedInMetersPerSecond;

  const Position({
    required this.coordinates,
    required this.speedInMetersPerSecond,
  });

  @override
  List<Object?> get props => [coordinates, speedInMetersPerSecond];
}
