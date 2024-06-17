import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/place/place_repository.dart';
import '../../../data/repository/place_suggestion/place_suggestion_repository.dart';
import '../../../entity/coordinates.dart';
import '../../../entity/place.dart';
import '../../../entity/place_suggestion.dart';
import '../../service/location_service.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService _locationService;
  final PlaceSuggestionRepository _placeSuggestionRepository;
  final PlaceRepository _placeRepository;

  MapCubit(
    this._locationService,
    this._placeSuggestionRepository,
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

  Future<void> searchPlaceSuggestions(String query) async {
    emit(state.copyWith(
      status: MapStatus.loading,
    ));
    final List<PlaceSuggestion> suggestions =
        await _placeSuggestionRepository.searchPlaces(
      query: query,
      limit: 10,
    );
    emit(state.copyWith(
      status: MapStatus.success,
      placeSuggestions: suggestions,
    ));
  }

  Future<void> loadPlaceDetails(String placeId) async {
    emit(state.copyWith(
      status: MapStatus.loading,
    ));
    final Place? place = await _placeRepository.getPlaceById(placeId);
    emit(state.copyWith(
      status: MapStatus.success,
      centerLocation: place?.coordinates ?? state.centerLocation,
      selectedPlace: place,
    ));
  }

  void resetPlaceSuggestions() {
    emit(state.copyWith(
      placeSuggestions: null,
    ));
  }

  void resetSelectedPlace() {
    emit(state.copyWith(
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
