import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/coordinates.dart';

part 'map_state.freezed.dart';

enum MapStateStatus { loading, completed }

enum MapFocusMode { free, followUserLocation }

extension MapStateStatusExtensions on MapStateStatus {
  bool get isLoading => this == MapStateStatus.loading;
}

extension MapFocusModeExtensions on MapFocusMode {
  bool get isFollowingUserLocation => this == MapFocusMode.followUserLocation;
}

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(MapStateStatus.loading) MapStateStatus status,
    @Default(MapFocusMode.followUserLocation) MapFocusMode focusMode,
    Coordinates? centerLocation,
    Coordinates? userLocation,
  }) = _MapState;
}
