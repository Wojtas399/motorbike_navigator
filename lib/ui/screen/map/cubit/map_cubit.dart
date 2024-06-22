import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/navigation/navigation_repository.dart';
import '../../../../data/repository/place/place_repository.dart';
import '../../../../entity/coordinates.dart';
import '../../../../entity/navigation.dart';
import '../../../../entity/place.dart';
import '../../../service/location_service.dart';
import 'map_state.dart';

@injectable
class MapCubit extends Cubit<MapState> {
  final LocationService _locationService;
  final PlaceRepository _placeRepository;
  final NavigationRepository _navigationRepository;

  MapCubit(
    this._locationService,
    this._placeRepository,
    this._navigationRepository,
  ) : super(const MapState());

  Future<void> initialize() async {
    final Coordinates? currentLocation =
        await _locationService.getCurrentLocation();
    emit(state.copyWith(
      status: MapStatus.completed,
      centerLocation: currentLocation ?? state.centerLocation,
      userLocation: currentLocation,
    ));
  }

  void onCenterLocationChanged(Coordinates newCenterLocation) {
    emit(state.copyWith(
      status: MapStatus.completed,
      centerLocation: newCenterLocation,
    ));
  }

  void openRouteSelection() {
    emit(state.copyWith(
      mode: MapMode.routeSelection,
    ));
  }

  void closeRouteSelection() {
    emit(state.copyWith(
      mode: MapMode.preview,
    ));
  }

  Future<void> loadPlaceDetails({
    required String placeId,
    required String placeName,
  }) async {
    emit(state.copyWith(
      status: MapStatus.loading,
      searchQuery: placeName,
    ));
    final Place? place = await _placeRepository.getPlaceById(placeId);
    emit(state.copyWith(
      status: MapStatus.completed,
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
      searchQuery: '',
      centerLocation: state.userLocation ?? state.centerLocation,
      selectedPlace: null,
    ));
  }

  Future<void> loadNavigation({
    required String startPlaceId,
    required String destinationId,
  }) async {
    final Place? startPlace = await _placeRepository.getPlaceById(startPlaceId);
    final Place? destination =
        await _placeRepository.getPlaceById(destinationId);
    if (startPlace == null || destination == null) return;
    final Navigation? navigation =
        await _navigationRepository.loadNavigationByStartAndEndLocations(
      startLocation: startPlace.coordinates,
      endLocation: destination.coordinates,
    );
    if (navigation != null && navigation.routes.isNotEmpty) {
      emit(state.copyWith(
        status: MapStatus.waypointsLoaded,
        navigation: MapStateNavigation(
          startPlace: startPlace,
          destination: destination,
          wayPoints: navigation.routes.first.waypoints,
        ),
      ));
    }
  }
}
