import 'package:bloc_test/bloc_test.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/screen/route_form/cubit/route_form_cubit.dart';
import 'package:motorbike_navigator/ui/screen/route_form/cubit/route_form_state.dart';

void main() {
  RouteFormCubit createCubit() => RouteFormCubit();

  blocTest(
    'onStartPlaceQueryChanged, '
    'should update startPlace in state',
    build: () => createCubit(),
    act: (cubit) => cubit.onStartPlaceChanged(
      const PlaceSuggestion(id: 'p1', name: 'first place'),
    ),
    expect: () => [
      const RouteFormState(
        startPlace: PlaceSuggestion(id: 'p1', name: 'first place'),
      ),
    ],
  );

  blocTest(
    'onDestinationChanged, '
    'should update destination in state',
    build: () => createCubit(),
    act: (cubit) => cubit.onDestinationChanged(
      const PlaceSuggestion(id: 'p1', name: 'first place'),
    ),
    expect: () => [
      const RouteFormState(
        destination: PlaceSuggestion(id: 'p1', name: 'first place'),
      ),
    ],
  );

  blocTest(
    'swapPlaces, '
    'should swap values of startPlace and destination params',
    build: () => createCubit(),
    act: (cubit) {
      cubit.onStartPlaceChanged(
        const PlaceSuggestion(id: 'p1', name: 'first place'),
      );
      cubit.onDestinationChanged(
        const PlaceSuggestion(id: 'p2', name: 'second place'),
      );
      cubit.swapPlaces();
    },
    expect: () => [
      const RouteFormState(
        startPlace: PlaceSuggestion(id: 'p1', name: 'first place'),
      ),
      const RouteFormState(
        startPlace: PlaceSuggestion(id: 'p1', name: 'first place'),
        destination: PlaceSuggestion(id: 'p2', name: 'second place'),
      ),
      const RouteFormState(
        startPlace: PlaceSuggestion(id: 'p2', name: 'second place'),
        destination: PlaceSuggestion(id: 'p1', name: 'first place'),
      ),
    ],
  );
}
