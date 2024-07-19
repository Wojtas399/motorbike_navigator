import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/navigation/navigation_repository.dart';
import '../../../../data/repository/place/place_repository.dart';
import '../../../../entity/navigation.dart';
import '../../../../entity/place.dart';
import '../../../../entity/place_suggestion.dart';
import 'route_state.dart';

@injectable
class RouteCubit extends Cubit<RouteState> {
  final PlaceRepository _placeRepository;
  final NavigationRepository _navigationRepository;

  RouteCubit(
    this._placeRepository,
    this._navigationRepository,
  ) : super(const RouteState());

  void onStartPlaceSuggestionChanged(PlaceSuggestion startPlaceSuggestion) {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      startPlaceSuggestion: startPlaceSuggestion,
    ));
  }

  void onDestinationSuggestionChanged(PlaceSuggestion destinationSuggestion) {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      destinationSuggestion: destinationSuggestion,
    ));
  }

  void swapPlaceSuggestions() {
    emit(state.copyWith(
      status: RouteStateStatus.infill,
      startPlaceSuggestion: state.destinationSuggestion,
      destinationSuggestion: state.startPlaceSuggestion,
    ));
  }

  Future<void> loadNavigation() async {
    if (state.startPlaceSuggestion == null ||
        state.destinationSuggestion == null) {
      emit(state.copyWith(
        status: RouteStateStatus.formNotCompleted,
      ));
      return;
    }
    emit(state.copyWith(
      status: RouteStateStatus.searching,
    ));
    final Place? startPlace =
        await _placeRepository.getPlaceById(state.startPlaceSuggestion!.id);
    final Place? destination =
        await _placeRepository.getPlaceById(state.destinationSuggestion!.id);
    if (startPlace == null || destination == null) return;
    final Navigation? navigation =
        await _navigationRepository.loadNavigationByStartAndEndLocations(
      startLocation: startPlace.coordinates,
      endLocation: destination.coordinates,
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
}
