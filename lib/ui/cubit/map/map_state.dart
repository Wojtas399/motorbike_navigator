import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entity/coordinates.dart';

part 'map_state.freezed.dart';

enum MapStatus { loading, completed }

enum MapFocusMode { free, followUserLocation }

extension MapStatusExtensions on MapStatus {
  bool get isLoading => this == MapStatus.loading;
}

extension MapFocusModeExtensions on MapFocusMode {
  bool get isFollowingUserLocation => this == MapFocusMode.followUserLocation;
}

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(MapStatus.loading) MapStatus status,
    @Default(MapFocusMode.followUserLocation) MapFocusMode focusMode,
    Coordinates? centerLocation,
    Coordinates? userLocation,
  }) = _MapState;
}
