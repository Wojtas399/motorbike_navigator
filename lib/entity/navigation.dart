import 'package:equatable/equatable.dart';

import 'coordinates.dart';
import 'entity.dart';

class Navigation extends Entity {
  final List<Route> routes;

  const Navigation({
    required super.id,
    required this.routes,
  });

  @override
  List<Object?> get props => [id, routes];
}

class Route extends Equatable {
  final double distanceInMeters;
  final List<Coordinates> waypoints;

  const Route({
    required this.distanceInMeters,
    required this.waypoints,
  });

  @override
  List<Object?> get props => [
        distanceInMeters,
        waypoints,
      ];
}
