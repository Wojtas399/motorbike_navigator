import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/position.dart';
import '../../../service/location_service.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService _locationService;
  StreamSubscription<Position?>? _currentPositionListener;

  MapCubit(
    this._locationService,
  ) : super(const MapState());

  @override
  Future<void> close() {
    _currentPositionListener?.cancel();
    return super.close();
  }

  void initialize() {
    _currentPositionListener ??= _locationService
        .getLocationStatus()
        .switchMap(
          (LocationStatus status) => switch (status) {
            LocationStatus.on => _locationService.getPosition(),
            LocationStatus.off => Stream.value(null),
          },
        )
        .listen(_handleCurrentPosition);
  }

  void onMapDrag(Coordinates newCenterLocation) {
    emit(state.copyWith(
      status: MapStateStatus.completed,
      focusMode: MapFocusMode.free,
      centerLocation: newCenterLocation,
    ));
  }

  void stopFollowingUserLocation() {
    emit(state.copyWith(
      focusMode: MapFocusMode.free,
    ));
  }

  void followUserLocation() {
    if (state.userPosition == null) return;
    emit(state.copyWith(
      focusMode: MapFocusMode.followUserLocation,
      centerLocation: state.userPosition!.coordinates,
    ));
  }

  void changeMode(MapMode newMode) {
    emit(state.copyWith(
      status: MapStateStatus.completed,
      mode: newMode,
    ));
  }

  void _handleCurrentPosition(Position? position) {
    if (position != null) {
      emit(state.copyWith(
        status: MapStateStatus.completed,
        centerLocation: state.focusMode.isFollowingUserLocation
            ? position.coordinates
            : state.centerLocation,
        userPosition: position,
      ));
    }
  }
}
