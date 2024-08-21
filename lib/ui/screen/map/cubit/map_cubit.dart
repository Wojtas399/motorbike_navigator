import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../entity/coordinates.dart';
import '../../../../entity/position.dart';
import '../../../service/location_service.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService _locationService;
  StreamSubscription<LocationStatus>? _locationStatusListener;
  StreamSubscription<Position>? _currentPositionListener;

  MapCubit(
    this._locationService,
  ) : super(const MapState());

  @override
  Future<void> close() {
    _locationStatusListener?.cancel();
    _currentPositionListener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _locationStatusListener =
        _locationService.getLocationStatus().listen(_handleLocationStatus);
  }

  Future<void> refreshLocationPermission() async {
    emit(state.copyWith(
      status: MapStateStatus.loading,
    ));
    _listenToCurrentPosition();
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

  void _handleLocationStatus(LocationStatus status) {
    switch (status) {
      case LocationStatus.on:
        _listenToCurrentPosition();
      case LocationStatus.off:
        _currentPositionListener?.cancel();
        emit(state.copyWith(
          status: MapStateStatus.locationIsOff,
        ));
    }
  }

  Future<void> _listenToCurrentPosition() async {
    final bool isLocationEnabled = await _locationService.hasPermission();
    if (!isLocationEnabled) {
      emit(state.copyWith(
        status: MapStateStatus.locationAccessDenied,
      ));
      return;
    }
    _currentPositionListener =
        _locationService.getPosition().listen(_handleCurrentPosition);
  }

  void _handleCurrentPosition(Position position) {
    emit(state.copyWith(
      status: MapStateStatus.completed,
      centerLocation: state.focusMode.isFollowingUserLocation
          ? position.coordinates
          : state.centerLocation,
      userPosition: position,
    ));
  }
}
