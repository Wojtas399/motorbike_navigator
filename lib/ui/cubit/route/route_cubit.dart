import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/navigation/navigation_repository.dart';
import '../../../../data/repository/place/place_repository.dart';
import '../../../entity/coordinates.dart';
import '../../../entity/navigation.dart';
import '../../../entity/position.dart';
import '../../service/location_service.dart';
import 'route_state.dart';

@injectable
class RouteCubit extends Cubit<RouteState> {
  final LocationService _locationService;
  final PlaceRepository _placeRepository;
  final NavigationRepository _navigationRepository;

  RouteCubit(
    this._locationService,
    this._placeRepository,
    this._navigationRepository,
  ) : super(const RouteState());

  void onStartPlaceChanged(RoutePlace routePlace) {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      startPlace: routePlace,
    ));
  }

  void onDestinationChanged(RoutePlace destination) {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      destination: destination,
    ));
  }

  void swapPlaceSuggestions() {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      startPlace: state.destination,
      destination: state.startPlace,
    ));
  }

  Future<void> loadNavigation() async {
    if (state.startPlace == null || state.destination == null) {
      emit(state.copyWith(
        status: RouteStateStatus.formNotCompleted,
      ));
      return;
    }
    emit(state.copyWith(
      status: RouteStateStatus.searching,
    ));
    final Coordinates? startLocation =
        await _loadRoutePlaceCoordinates(state.startPlace!);
    final Coordinates? endLocation =
        await _loadRoutePlaceCoordinates(state.destination!);
    if (startLocation == null || endLocation == null) return;
    final Navigation? navigation =
        await _navigationRepository.loadNavigationByStartAndEndLocations(
      startLocation: startLocation,
      endLocation: endLocation,
    );
    if (navigation != null && navigation.routes.isNotEmpty) {
      emit(state.copyWith(
        status: RouteStateStatus.routeFound,
        route: navigation.routes.first,
      ));
    } else {
      emit(state.copyWith(
        status: RouteStateStatus.routeNotFound,
      ));
    }
  }

  void resetRoute() {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      route: null,
    ));
  }

  void reset() {
    emit(const RouteState());
  }

  Future<Coordinates?> _loadRoutePlaceCoordinates(RoutePlace place) async {
    if (place is UserLocationRoutePlace) {
      return await _loadCurrentLocation();
    } else if (place is SelectedRoutePlace) {
      return (await _placeRepository.getPlaceById(place.id))?.coordinates;
    }
    return null;
  }

  Future<Coordinates?> _loadCurrentLocation() async => await _locationService
      .getPosition()
      .map((Position? position) => position?.coordinates)
      .first;
}
