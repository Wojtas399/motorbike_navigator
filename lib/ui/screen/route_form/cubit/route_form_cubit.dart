import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../entity/place_suggestion.dart';
import 'route_form_state.dart';

@injectable
class RouteFormCubit extends Cubit<RouteFormState> {
  RouteFormCubit() : super(const RouteFormState());

  void onStartPlaceChanged(PlaceSuggestion? startPlace) {
    emit(state.copyWith(
      startPlace: startPlace,
    ));
  }

  void onDestinationChanged(PlaceSuggestion? destination) {
    emit(state.copyWith(
      destination: destination,
    ));
  }

  void swapPlaces() {
    emit(state.copyWith(
      startPlace: state.destination,
      destination: state.startPlace,
    ));
  }
}
