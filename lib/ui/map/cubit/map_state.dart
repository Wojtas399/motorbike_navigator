import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/place.dart';
import '../../../entity/place_suggestion.dart';

part 'map_state.freezed.dart';

enum MapStatus { initial, loading, success, failure }

extension MapStatusExtensions on MapStatus {
  bool get isInitial => this == MapStatus.initial;
  bool get isLoading => this == MapStatus.loading;
  bool get isSuccess => this == MapStatus.success;
}

enum MapMode { map, search }

extension MapModeExtensions on MapMode {
  bool get isSearch => this == MapMode.search;
}

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(MapStatus.initial) MapStatus status,
    @Default(MapMode.map) MapMode mode,
    Coordinates? currentLocation,
    List<PlaceSuggestion>? placeSuggestions,
    Place? selectedPlace,
  }) = _MapState;
}
