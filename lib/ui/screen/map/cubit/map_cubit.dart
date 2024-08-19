import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../entity/coordinates.dart';
import '../../../exception/location_exception.dart';
import '../../../service/location_service.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService _locationService;

  MapCubit(
    this._locationService,
  ) : super(const MapState());

  Future<void> initialize() async {
    try {
      final currentPosition$ = _locationService.getPosition();
      await for (final currentPosition in currentPosition$) {
        emit(state.copyWith(
          status: MapStateStatus.completed,
          centerLocation: state.focusMode.isFollowingUserLocation
              ? currentPosition.coordinates
              : state.centerLocation,
          userPosition: currentPosition,
        ));
      }
    } on LocationException catch (exception) {
      if (exception is LocationExceptionAccessDenied) {
        emit(state.copyWith(
          status: MapStateStatus.gpsAccessDenied,
        ));
      }
    }
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
}
