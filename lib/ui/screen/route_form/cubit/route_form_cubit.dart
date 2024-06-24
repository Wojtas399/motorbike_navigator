import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/navigation/navigation_repository.dart';
import '../../../../data/repository/place/place_repository.dart';
import '../../../../entity/navigation.dart';
import '../../../../entity/place.dart';
import '../../../../entity/place_suggestion.dart';
import 'route_form_state.dart';

@injectable
class RouteFormCubit extends Cubit<RouteFormState> {
  final PlaceRepository _placeRepository;
  final NavigationRepository _navigationRepository;

  RouteFormCubit(
    this._placeRepository,
    this._navigationRepository,
  ) : super(const RouteFormState());

  void onStartPlaceSuggestionChanged(PlaceSuggestion startPlaceSuggestion) {
    emit(state.copyWith(
      startPlaceSuggestion: startPlaceSuggestion,
    ));
  }

  void onDestinationSuggestionChanged(PlaceSuggestion destinationSuggestion) {
    emit(state.copyWith(
      destinationSuggestion: destinationSuggestion,
    ));
  }

  void swapPlaceSuggestions() {
    emit(state.copyWith(
      startPlaceSuggestion: state.destinationSuggestion,
      destinationSuggestion: state.startPlaceSuggestion,
    ));
  }

  Future<void> loadNavigation() async {
    if (state.startPlaceSuggestion == null ||
        state.destinationSuggestion == null) return;
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
        route: navigation.routes.first,
      ));
    }
  }
}
