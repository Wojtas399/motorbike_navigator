import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/place.dart';

part 'map_state.freezed.dart';

enum MapStatus { loading, completed, waypointsLoaded }

extension MapStatusExtensions on MapStatus {
  bool get isLoading => this == MapStatus.loading;
}

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(MapStatus.loading) MapStatus status,
    @Default('') String searchQuery,
    @Default(_defaultLocation) Coordinates centerLocation,
    Coordinates? userLocation,
    Place? selectedPlace,
    MapStateNavigation? navigation,
  }) = _MapState;
}

class MapStateNavigation extends Equatable {
  final Place startPlace;
  final Place destination;
  final List<Coordinates> wayPoints;

  const MapStateNavigation({
    required this.startPlace,
    required this.destination,
    required this.wayPoints,
  });

  @override
  List<Object?> get props => [startPlace, destination, wayPoints];
}

const Coordinates _defaultLocation = Coordinates(
  52.23178179122954,
  21.006002101026827,
);
