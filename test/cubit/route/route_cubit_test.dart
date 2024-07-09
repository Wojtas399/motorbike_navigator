import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/navigation.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_state.dart';

import '../../creator/place_creator.dart';
import '../../mock/data/repository/mock_navigation_repository.dart';
import '../../mock/data/repository/mock_place_repository.dart';

void main() {
  final placeRepository = MockPlaceRepository();
  final navigationRepository = MockNavigationRepository();
  final placeCreator = PlaceCreator();

  RouteCubit createCubit() => RouteCubit(
        placeRepository,
        navigationRepository,
      );

  blocTest(
    'onStartPlaceSuggestionChanged, '
    'should update startPlaceSuggestion in state',
    build: () => createCubit(),
    act: (cubit) => cubit.onStartPlaceSuggestionChanged(
      const PlaceSuggestion(id: 'p1', name: 'place suggestion'),
    ),
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(
          id: 'p1',
          name: 'place suggestion',
        ),
      ),
    ],
  );

  blocTest(
    'onDestinationSuggestionChanged, ',
    build: () => createCubit(),
    act: (cubit) => cubit.onDestinationSuggestionChanged(
      const PlaceSuggestion(id: 'p1', name: 'place suggestion'),
    ),
    expect: () => [
      const RouteState(
        destinationSuggestion: PlaceSuggestion(
          id: 'p1',
          name: 'place suggestion',
        ),
      ),
    ],
  );

  blocTest(
    'swapPlaceSuggestions, '
    'should swap values of startPlaceSuggestion and destinationSuggestion',
    build: () => createCubit(),
    act: (cubit) {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'start place'),
      );
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'destination'),
      );
      cubit.swapPlaceSuggestions();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'start place'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'start place'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'destination'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p2', name: 'destination'),
        destinationSuggestion: PlaceSuggestion(id: 'p1', name: 'start place'),
      ),
    ],
  );

  blocTest(
    'loadNavigation, '
    'startPlaceSuggestion is null, '
    'should finish method call',
    build: () => createCubit(),
    act: (cubit) async {
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      );
      await cubit.loadNavigation();
    },
    expect: () => [
      const RouteState(
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
      ),
    ],
  );

  blocTest(
    'loadNavigation, '
    'destinationSuggestion is null, '
    'should finish method call',
    build: () => createCubit(),
    act: (cubit) async {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
      );
      await cubit.loadNavigation();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
      ),
    ],
  );

  blocTest(
    'loadNavigation, '
    'start place does not exist, '
    'should finish method call',
    build: () => createCubit(),
    setUp: () {
      when(
        () => placeRepository.getPlaceById('p1'),
      ).thenAnswer((_) => Future.value(null));
      when(
        () => placeRepository.getPlaceById('p2'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          coordinates: const Coordinates(51.2, 19.2),
        )),
      );
    },
    act: (cubit) async {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
      );
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      );
      await cubit.loadNavigation();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
      ),
    ],
    verify: (_) {
      verify(() => placeRepository.getPlaceById('p1')).called(1);
      verify(() => placeRepository.getPlaceById('p2')).called(1);
    },
  );

  blocTest(
    'loadNavigation, '
    'destination does not exist, '
    'should finish method call',
    build: () => createCubit(),
    setUp: () {
      when(
        () => placeRepository.getPlaceById('p1'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          coordinates: const Coordinates(51.2, 19.2),
        )),
      );
      when(
        () => placeRepository.getPlaceById('p2'),
      ).thenAnswer((_) => Future.value(null));
    },
    act: (cubit) async {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
      );
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      );
      await cubit.loadNavigation();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
      ),
    ],
    verify: (_) {
      verify(() => placeRepository.getPlaceById('p1')).called(1);
      verify(() => placeRepository.getPlaceById('p2')).called(1);
    },
  );

  blocTest(
    'loadNavigation, '
    'navigation does not exist, '
    'should finish method call',
    build: () => createCubit(),
    setUp: () {
      when(
        () => placeRepository.getPlaceById('p1'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          coordinates: const Coordinates(50.1, 18.1),
        )),
      );
      when(
        () => placeRepository.getPlaceById('p2'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          coordinates: const Coordinates(51.2, 19.2),
        )),
      );
      navigationRepository.mockLoadNavigationByStartAndEndLocations(
        navigation: null,
      );
    },
    act: (cubit) async {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
      );
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      );
      await cubit.loadNavigation();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
      ),
    ],
    verify: (_) {
      verify(() => placeRepository.getPlaceById('p1')).called(1);
      verify(() => placeRepository.getPlaceById('p2')).called(1);
      verify(
        () => navigationRepository.loadNavigationByStartAndEndLocations(
          startLocation: const Coordinates(50.1, 18.1),
          endLocation: const Coordinates(51.2, 19.2),
        ),
      ).called(1);
    },
  );

  blocTest(
    'loadNavigation, '
    'navigation does not contain any routes, '
    'should finish method call',
    build: () => createCubit(),
    setUp: () {
      when(
        () => placeRepository.getPlaceById('p1'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          coordinates: const Coordinates(50.1, 18.1),
        )),
      );
      when(
        () => placeRepository.getPlaceById('p2'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          coordinates: const Coordinates(51.2, 19.2),
        )),
      );
      navigationRepository.mockLoadNavigationByStartAndEndLocations(
        navigation: Navigation(
          startLocation: const Coordinates(50.1, 18.1),
          endLocation: const Coordinates(51.2, 19.2),
          routes: const [],
        ),
      );
    },
    act: (cubit) async {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
      );
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      );
      await cubit.loadNavigation();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
      ),
    ],
    verify: (_) {
      verify(() => placeRepository.getPlaceById('p1')).called(1);
      verify(() => placeRepository.getPlaceById('p2')).called(1);
      verify(
        () => navigationRepository.loadNavigationByStartAndEndLocations(
          startLocation: const Coordinates(50.1, 18.1),
          endLocation: const Coordinates(51.2, 19.2),
        ),
      ).called(1);
    },
  );

  blocTest(
    'loadNavigation, '
    'should load coordinates of start and destination places, should load '
    'routes between these two locations and should emit first of the routes',
    build: () => createCubit(),
    setUp: () {
      when(
        () => placeRepository.getPlaceById('p1'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          id: 'p1',
          coordinates: const Coordinates(50.1, 18.1),
        )),
      );
      when(
        () => placeRepository.getPlaceById('p2'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          id: 'p2',
          coordinates: const Coordinates(51.2, 19.2),
        )),
      );
      navigationRepository.mockLoadNavigationByStartAndEndLocations(
        navigation: Navigation(
          startLocation: const Coordinates(50.1, 18.1),
          endLocation: const Coordinates(51.2, 19.2),
          routes: const [
            Route(
              durationInSeconds: 333.333,
              distanceInMeters: 1000.1,
              waypoints: [
                Coordinates(50.25, 18.25),
                Coordinates(50.5, 18.5),
              ],
            ),
            Route(
              durationInSeconds: 222.222,
              distanceInMeters: 2000.2,
              waypoints: [
                Coordinates(50.25, 18.25),
                Coordinates(50.5, 18.5),
              ],
            ),
          ],
        ),
      );
    },
    act: (cubit) async {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
      );
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      );
      await cubit.loadNavigation();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
        route: Route(
          durationInSeconds: 333.333,
          distanceInMeters: 1000.1,
          waypoints: [
            Coordinates(50.25, 18.25),
            Coordinates(50.5, 18.5),
          ],
        ),
      ),
    ],
    verify: (_) {
      verify(() => placeRepository.getPlaceById('p1')).called(1);
      verify(() => placeRepository.getPlaceById('p2')).called(1);
      verify(
        () => navigationRepository.loadNavigationByStartAndEndLocations(
          startLocation: const Coordinates(50.1, 18.1),
          endLocation: const Coordinates(51.2, 19.2),
        ),
      ).called(1);
    },
  );

  blocTest(
    'reset, '
    'should set initial state values',
    build: () => createCubit(),
    setUp: () {
      when(
        () => placeRepository.getPlaceById('p1'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          id: 'p1',
          coordinates: const Coordinates(50.1, 18.1),
        )),
      );
      when(
        () => placeRepository.getPlaceById('p2'),
      ).thenAnswer(
        (_) => Future.value(placeCreator.create(
          id: 'p2',
          coordinates: const Coordinates(51.2, 19.2),
        )),
      );
      navigationRepository.mockLoadNavigationByStartAndEndLocations(
        navigation: Navigation(
          startLocation: const Coordinates(50.1, 18.1),
          endLocation: const Coordinates(51.2, 19.2),
          routes: const [
            Route(
              durationInSeconds: 333.333,
              distanceInMeters: 1000.1,
              waypoints: [
                Coordinates(50.25, 18.25),
                Coordinates(50.5, 18.5),
              ],
            ),
          ],
        ),
      );
    },
    act: (cubit) async {
      cubit.onStartPlaceSuggestionChanged(
        const PlaceSuggestion(id: 'p1', name: 'place 1'),
      );
      cubit.onDestinationSuggestionChanged(
        const PlaceSuggestion(id: 'p2', name: 'place 2'),
      );
      await cubit.loadNavigation();
      cubit.reset();
    },
    expect: () => [
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
      ),
      const RouteState(
        startPlaceSuggestion: PlaceSuggestion(id: 'p1', name: 'place 1'),
        destinationSuggestion: PlaceSuggestion(id: 'p2', name: 'place 2'),
        route: Route(
          durationInSeconds: 333.333,
          distanceInMeters: 1000.1,
          waypoints: [
            Coordinates(50.25, 18.25),
            Coordinates(50.5, 18.5),
          ],
        ),
      ),
      const RouteState(),
    ],
  );
}
