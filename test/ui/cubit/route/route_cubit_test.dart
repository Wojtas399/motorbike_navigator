import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/navigation.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_state.dart';

import '../../../creator/place_creator.dart';
import '../../../mock/data/repository/mock_navigation_repository.dart';
import '../../../mock/data/repository/mock_place_repository.dart';

void main() {
  final placeRepository = MockPlaceRepository();
  final navigationRepository = MockNavigationRepository();
  final placeCreator = PlaceCreator();

  RouteCubit createCubit() => RouteCubit(
        placeRepository,
        navigationRepository,
      );

  group(
    'onStartPlaceSuggestionChanged, ',
    () {
      const expectedPlaceSuggestion = PlaceSuggestion(
        id: 'p1',
        name: 'place suggestion',
      );

      blocTest(
        'should update startPlaceSuggestion and should set status as infill',
        build: () => createCubit(),
        act: (cubit) => cubit.onStartPlaceSuggestionChanged(
          expectedPlaceSuggestion,
        ),
        expect: () => [
          const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: expectedPlaceSuggestion,
          ),
        ],
      );
    },
  );

  group(
    'onDestinationSuggestionChanged, ',
    () {
      const expectedPlaceSuggestion = PlaceSuggestion(
        id: 'p1',
        name: 'place suggestion',
      );

      blocTest(
        'should update destinationSuggestion and should set status as infill',
        build: () => createCubit(),
        act: (cubit) => cubit.onDestinationSuggestionChanged(
          expectedPlaceSuggestion,
        ),
        expect: () => [
          const RouteState(
            status: RouteStateStatus.infill,
            destinationSuggestion: expectedPlaceSuggestion,
          ),
        ],
      );
    },
  );

  group(
    'swapPlaceSuggestions, ',
    () {
      const startPlaceSuggestion = PlaceSuggestion(
        id: 'p1',
        name: 'start place',
      );
      const destinationSuggestion = PlaceSuggestion(
        id: 'p2',
        name: 'destination',
      );
      RouteState? state;

      blocTest(
        'should swap values of startPlaceSuggestion and destinationSuggestion',
        build: () => createCubit(),
        act: (cubit) {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          cubit.swapPlaceSuggestions();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            startPlaceSuggestion: destinationSuggestion,
            destinationSuggestion: startPlaceSuggestion,
          ),
        ],
      );

      blocTest(
        'should set status as infill',
        build: () => createCubit(),
        act: (cubit) => cubit.swapPlaceSuggestions(),
        expect: () => [
          const RouteState(
            status: RouteStateStatus.infill,
          ),
        ],
      );
    },
  );

  group(
    'loadNavigation, ',
    () {
      const startPlaceSuggestion = PlaceSuggestion(id: 'p1', name: 'place 1');
      const destinationSuggestion = PlaceSuggestion(id: 'p2', name: 'place 2');
      final startPlace = placeCreator.create(
        id: startPlaceSuggestion.id,
        coordinates: const Coordinates(50.1, 18.1),
      );
      final destination = placeCreator.create(
        id: destinationSuggestion.id,
        coordinates: const Coordinates(51.2, 19.2),
      );
      final navigation = Navigation(
        startLocation: startPlace.coordinates,
        endLocation: destination.coordinates,
        routes: const [
          Route(
            duration: Duration(minutes: 10),
            distanceInMeters: 1000.1,
            waypoints: [
              Coordinates(50.25, 18.25),
              Coordinates(50.5, 18.5),
            ],
          ),
          Route(
            duration: Duration(minutes: 20),
            distanceInMeters: 2000.2,
            waypoints: [
              Coordinates(50.25, 18.25),
              Coordinates(50.5, 18.5),
            ],
          ),
        ],
      );
      RouteState? state;

      blocTest(
        'should emit status set as formNotCompleted if startPlaceSuggestion '
        'param is null',
        build: () => createCubit(),
        act: (cubit) async {
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.formNotCompleted,
          ),
        ],
      );

      blocTest(
        'should emit status set as formNotCompleted if destinationSuggestion '
        'param is null',
        build: () => createCubit(),
        act: (cubit) async {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.formNotCompleted,
          ),
        ],
      );

      blocTest(
        'should finish method call if start place has not been found in '
        'PlaceRepository',
        build: () => createCubit(),
        setUp: () {
          when(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).thenAnswer((_) => Future.value(null));
          when(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).thenAnswer((_) => Future.value(destination));
        },
        act: (cubit) async {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
        ],
        verify: (_) {
          verify(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).called(1);
          verify(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).called(1);
        },
      );

      blocTest(
        'should finish method call if destination has not been found in '
        'PlaceRepository',
        build: () => createCubit(),
        setUp: () {
          when(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).thenAnswer((_) => Future.value(startPlace));
          when(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).thenAnswer((_) => Future.value(null));
        },
        act: (cubit) async {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
        ],
        verify: (_) {
          verify(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).called(1);
          verify(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).called(1);
        },
      );

      blocTest(
        'should emit routeNotFound status if navigation has not been found in '
        'NavigationRepository',
        build: () => createCubit(),
        setUp: () {
          when(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).thenAnswer((_) => Future.value(startPlace));
          when(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).thenAnswer((_) => Future.value(destination));
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: null,
          );
        },
        act: (cubit) async {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeNotFound,
          ),
        ],
        verify: (_) {
          verify(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).called(1);
          verify(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).called(1);
          verify(
            () => navigationRepository.loadNavigationByStartAndEndLocations(
              startLocation: startPlace.coordinates,
              endLocation: destination.coordinates,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit routeNotFound status if found navigation does not contain '
        'any routes',
        build: () => createCubit(),
        setUp: () {
          when(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).thenAnswer((_) => Future.value(startPlace));
          when(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).thenAnswer((_) => Future.value(destination));
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: Navigation(
              startLocation: startPlace.coordinates,
              endLocation: destination.coordinates,
              routes: const [],
            ),
          );
        },
        act: (cubit) async {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeNotFound,
          ),
        ],
        verify: (_) {
          verify(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).called(1);
          verify(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).called(1);
          verify(
            () => navigationRepository.loadNavigationByStartAndEndLocations(
              startLocation: startPlace.coordinates,
              endLocation: destination.coordinates,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should load coordinates of start and destination places, should load '
        'routes between these two locations and should emit first of the routes',
        build: () => createCubit(),
        setUp: () {
          when(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).thenAnswer((_) => Future.value(startPlace));
          when(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).thenAnswer((_) => Future.value(destination));
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: navigation,
          );
        },
        act: (cubit) async {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeFound,
            route: navigation.routes.first,
          ),
        ],
        verify: (_) {
          verify(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).called(1);
          verify(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).called(1);
          verify(
            () => navigationRepository.loadNavigationByStartAndEndLocations(
              startLocation: startPlace.coordinates,
              endLocation: destination.coordinates,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'reset, ',
    () {
      const startPlaceSuggestion = PlaceSuggestion(id: 'p1', name: 'place 1');
      const destinationSuggestion = PlaceSuggestion(id: 'p2', name: 'place 2');
      final startPlace = placeCreator.create(
        id: startPlaceSuggestion.id,
        coordinates: const Coordinates(50.1, 18.1),
      );
      final destination = placeCreator.create(
        id: destinationSuggestion.id,
        coordinates: const Coordinates(51.2, 19.2),
      );
      final navigation = Navigation(
        startLocation: startPlace.coordinates,
        endLocation: destination.coordinates,
        routes: const [
          Route(
            duration: Duration(minutes: 10),
            distanceInMeters: 1000.1,
            waypoints: [
              Coordinates(50.25, 18.25),
              Coordinates(50.5, 18.5),
            ],
          ),
        ],
      );
      RouteState? state;

      blocTest(
        'should set default state',
        build: () => createCubit(),
        setUp: () {
          when(
            () => placeRepository.getPlaceById(startPlaceSuggestion.id),
          ).thenAnswer((_) => Future.value(startPlace));
          when(
            () => placeRepository.getPlaceById(destinationSuggestion.id),
          ).thenAnswer((_) => Future.value(destination));
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: navigation,
          );
        },
        act: (cubit) async {
          cubit.onStartPlaceSuggestionChanged(startPlaceSuggestion);
          cubit.onDestinationSuggestionChanged(destinationSuggestion);
          await cubit.loadNavigation();
          cubit.reset();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPlaceSuggestion: startPlaceSuggestion,
          ),
          state = state?.copyWith(
            destinationSuggestion: destinationSuggestion,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeFound,
            route: navigation.routes.first,
          ),
          const RouteState(),
        ],
      );
    },
  );
}
