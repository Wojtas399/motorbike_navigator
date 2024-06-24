import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/coordinates.dart';

part 'map_state.freezed.dart';

enum MapStatus { loading, completed }

extension MapStatusExtensions on MapStatus {
  bool get isLoading => this == MapStatus.loading;
}

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(MapStatus.loading) MapStatus status,
    Coordinates? centerLocation,
    Coordinates? userLocation,
  }) = _MapState;
}
