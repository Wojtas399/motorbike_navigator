import 'package:equatable/equatable.dart';

import 'coordinates.dart';
import 'entity.dart';

class Navigation extends Entity {
  final Coordinates startLocation;
  final Coordinates endLocation;
  final List<Route> routes;

  Navigation({
    required this.startLocation,
    required this.endLocation,
    required this.routes,
  }) : super(
          id: '${startLocation.latitude},${startLocation.longitude};${endLocation.latitude},${endLocation.longitude}',
        );

  @override
  List<Object?> get props => [id, startLocation, endLocation, routes];
}

class Route extends Equatable {
  final Duration duration;
  final double distanceInMeters;
  final List<Coordinates> waypoints;

  const Route({
    required this.duration,
    required this.distanceInMeters,
    required this.waypoints,
  });

  @override
  List<Object?> get props => [
        duration,
        distanceInMeters,
        waypoints,
      ];
}
