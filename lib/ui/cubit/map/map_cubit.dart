import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/position.dart';
import '../../service/location_service.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService _locationService;

  MapCubit(
    this._locationService,
  ) : super(const MapState());

  Future<void> initialize() async {
    final currentLocation$ = _getCurrentLocation();
    await for (final currentLocation in currentLocation$) {
      emit(state.copyWith(
        status: MapStatus.completed,
        centerLocation: state.centerLocation ?? currentLocation,
        userLocation: currentLocation,
      ));
    }
  }

  void onMapDrag(Coordinates newCenterLocation) {
    emit(state.copyWith(
      status: MapStatus.completed,
      focusMode: MapFocusMode.free,
      centerLocation: newCenterLocation,
    ));
  }

  void followUserLocation() {
    if (state.userLocation == null) return;
    emit(state.copyWith(
      focusMode: MapFocusMode.followUserLocation,
      centerLocation: state.userLocation!,
    ));
  }

  Stream<Coordinates?> _getCurrentLocation() =>
      _locationService.getPosition().map(
            (Position? position) => position?.coordinates,
          );
}
