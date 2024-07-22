import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/place/place_repository.dart';
import '../../../data/repository/route_suggestions/route_suggestions_repository.dart';
import '../../../entity/coordinates.dart';
import '../../../entity/map_point.dart';
import '../../../entity/route_suggestions.dart';
import '../../service/location_service.dart';
import 'route_state.dart';

@injectable
class RouteCubit extends Cubit<RouteState> {
  final LocationService _locationService;
  final PlaceRepository _placeRepository;
  final RouteSuggestionsRepository _routeSuggestionsRepository;

  RouteCubit(
    this._locationService,
    this._placeRepository,
    this._routeSuggestionsRepository,
  ) : super(const RouteState());

  void onStartPointChanged(MapPoint startPoint) {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      startPoint: startPoint,
    ));
  }

  void onEndPointChanged(MapPoint endPoint) {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      endPoint: endPoint,
    ));
  }

  void swapPoints() {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      startPoint: state.endPoint,
      endPoint: state.startPoint,
    ));
  }

  Future<void> loadNavigation() async {
    final RouteStateStatus? errorStatus = _getErrorStatusIfPointsAreInvalid();
    if (errorStatus != null) {
      emit(state.copyWith(
        status: errorStatus,
      ));
      return;
    }
    emit(state.copyWith(
      status: RouteStateStatus.searching,
    ));
    final Coordinates? startLocation =
        await _loadPointCoordinates(state.startPoint!);
    final Coordinates? endLocation =
        await _loadPointCoordinates(state.endPoint!);
    if (startLocation == null || endLocation == null) return;
    final RouteSuggestions? routeSuggestions = await _routeSuggestionsRepository
        .loadRouteSuggestionsByStartAndEndLocations(
      startLocation: startLocation,
      endLocation: endLocation,
    );
    if (routeSuggestions != null && routeSuggestions.routes.isNotEmpty) {
      emit(state.copyWith(
        status: RouteStateStatus.routeFound,
        route: routeSuggestions.routes.first,
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

  RouteStateStatus? _getErrorStatusIfPointsAreInvalid() {
    if (state.startPoint == null || state.endPoint == null) {
      return RouteStateStatus.formNotCompleted;
    } else if (state.startPoint == state.endPoint) {
      return RouteStateStatus.pointsMustBeDifferent;
    }
    return null;
  }

  Future<Coordinates?> _loadPointCoordinates(MapPoint point) async {
    if (point is UserLocationPoint) {
      return await _locationService.loadLocation();
    } else if (point is SelectedPlacePoint) {
      return (await _placeRepository.getPlaceById(point.id))?.coordinates;
    }
    return null;
  }
}
