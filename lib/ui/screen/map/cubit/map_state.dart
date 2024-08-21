import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/position.dart';

part 'map_state.freezed.dart';

enum MapStateStatus { loading, completed, locationIsOff, locationAccessDenied }

enum MapMode { basic, drive, selectingRoute, routePreview }

enum MapFocusMode { free, followUserLocation }

extension MapModeExtensions on MapMode {
  bool get isBasic => this == MapMode.basic;

  bool get isDrive => this == MapMode.drive;
}

extension MapFocusModeExtensions on MapFocusMode {
  bool get isFollowingUserLocation => this == MapFocusMode.followUserLocation;
}

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(MapStateStatus.loading) MapStateStatus status,
    @Default(MapMode.basic) MapMode mode,
    @Default(MapFocusMode.followUserLocation) MapFocusMode focusMode,
    Coordinates? centerLocation,
    Position? userPosition,
  }) = _MapState;
}
