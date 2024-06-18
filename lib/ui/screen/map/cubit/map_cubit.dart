import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/place/place_repository.dart';
import '../../../../entity/coordinates.dart';
import '../../../../entity/place.dart';
import '../../../service/location_service.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService _locationService;
  final PlaceRepository _placeRepository;

  MapCubit(
    this._locationService,
    this._placeRepository,
  ) : super(const MapState());

  Future<void> initialize() async {
    final Coordinates? currentLocation =
        await _locationService.getCurrentLocation();
    emit(state.copyWith(
      status: MapStatus.success,
      centerLocation: currentLocation ?? state.centerLocation,
      userLocation: currentLocation,
    ));
  }

  void onCenterLocationChanged(Coordinates newCenterLocation) {
    emit(state.copyWith(
      centerLocation: newCenterLocation,
    ));
  }

  Future<void> loadPlaceDetails(String placeId, String searchQuery) async {
    emit(state.copyWith(
      status: MapStatus.loading,
    ));
    final Place? place = await _placeRepository.getPlaceById(placeId);
    emit(state.copyWith(
      status: MapStatus.success,
      searchQuery: searchQuery,
      centerLocation: place?.coordinates ?? state.centerLocation,
      selectedPlace: place,
    ));
  }

  void resetSelectedPlace() {
    emit(state.copyWith(
      searchQuery: '',
      selectedPlace: null,
    ));
  }

  void moveBackToUserLocation() {
    emit(state.copyWith(
      centerLocation: state.userLocation ?? state.centerLocation,
      selectedPlace: null,
    ));
  }
}
