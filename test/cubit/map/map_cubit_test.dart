import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';
import 'package:motorbike_navigator/ui/map/cubit/map_cubit.dart';
import 'package:motorbike_navigator/ui/map/cubit/map_state.dart';

import '../../creator/place_creator.dart';
import '../../mock/data/repository/mock_place_repository.dart';
import '../../mock/data/repository/mock_place_suggestion_repository.dart';
import '../../mock/ui_service/mock_location_service.dart';

void main() {
  final locationService = MockLocationService();
  final placeSuggestionRepository = MockPlaceSuggestionRepository();
  final placeRepository = MockPlaceRepository();

  MapCubit createCubit() => MapCubit(
        locationService,
        placeSuggestionRepository,
        placeRepository,
      );

  blocTest(
    'initialize, '
    'should get current location from LocationService and should assign it to '
    'displayedLocation and userLocation params',
    setUp: () => locationService.mockGetCurrentLocation(
      result: const Coordinates(50.2, 25.4),
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const MapState(
        status: MapStatus.success,
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'current location is null, '
    'should only emit success status',
    setUp: () => locationService.mockGetCurrentLocation(
      result: null,
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const MapState(
        status: MapStatus.success,
      ),
    ],
  );

  blocTest(
    'changeMode, '
    'should change mode in state',
    build: () => createCubit(),
    act: (cubit) => cubit.changeMode(MapMode.search),
    expect: () => [
      const MapState(
        mode: MapMode.search,
      ),
    ],
  );

  blocTest(
    'searchPlaceSuggestions, '
    'should get place suggestions from PlaceRepository limited to 10 suggestions',
    setUp: () => placeSuggestionRepository.mockSearchPlaces(
      result: const [
        PlaceSuggestion(id: 'p1', name: 'place 1', fullAddress: 'address 1'),
        PlaceSuggestion(id: 'p2', name: 'place 2', fullAddress: 'address 2'),
        PlaceSuggestion(id: 'p3', name: 'place 3', fullAddress: 'address 3'),
      ],
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.searchPlaceSuggestions('query'),
    expect: () => [
      const MapState(
        status: MapStatus.loading,
      ),
      const MapState(
        status: MapStatus.success,
        placeSuggestions: [
          PlaceSuggestion(id: 'p1', name: 'place 1', fullAddress: 'address 1'),
          PlaceSuggestion(id: 'p2', name: 'place 2', fullAddress: 'address 2'),
          PlaceSuggestion(id: 'p3', name: 'place 3', fullAddress: 'address 3'),
        ],
      )
    ],
    verify: (_) => verify(
      () => placeSuggestionRepository.searchPlaces(
        query: 'query',
        limit: 10,
      ),
    ).called(1),
  );

  blocTest(
    'loadPlaceDetails, '
    'should get place details from PlaceRepository, should set mode to map and '
    'should change displayedLocation and selectedPlace params',
    setUp: () => placeRepository.mockGetPlaceById(
      result: createPlace(
        id: 'p1',
        name: 'place 1',
        coordinates: const Coordinates(50.1, 12.1),
      ),
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.loadPlaceDetails('p1'),
    expect: () => [
      const MapState(
        status: MapStatus.loading,
      ),
      MapState(
        status: MapStatus.success,
        mode: MapMode.map,
        centerLocation: const Coordinates(50.1, 12.1),
        selectedPlace: createPlace(
          id: 'p1',
          name: 'place 1',
          coordinates: const Coordinates(50.1, 12.1),
        ),
      ),
    ],
    verify: (_) => verify(
      () => placeRepository.getPlaceById('p1'),
    ).called(1),
  );

  blocTest(
    'resetPlaceSuggestions, '
    'should set placeSuggestions param as null',
    setUp: () => placeSuggestionRepository.mockSearchPlaces(
      result: const [
        PlaceSuggestion(id: 'p1', name: 'place 1', fullAddress: 'address 1'),
        PlaceSuggestion(id: 'p2', name: 'place 2', fullAddress: 'address 2'),
        PlaceSuggestion(id: 'p3', name: 'place 3', fullAddress: 'address 3'),
      ],
    ),
    build: () => createCubit(),
    act: (cubit) async {
      await cubit.searchPlaceSuggestions('query');
      cubit.resetPlaceSuggestions();
    },
    expect: () => [
      const MapState(
        status: MapStatus.loading,
      ),
      const MapState(
        status: MapStatus.success,
        placeSuggestions: [
          PlaceSuggestion(id: 'p1', name: 'place 1', fullAddress: 'address 1'),
          PlaceSuggestion(id: 'p2', name: 'place 2', fullAddress: 'address 2'),
          PlaceSuggestion(id: 'p3', name: 'place 3', fullAddress: 'address 3'),
        ],
      ),
      const MapState(
        status: MapStatus.success,
        placeSuggestions: null,
      ),
    ],
  );

  blocTest(
    'resetSelectedPlace, '
    'should set selectedPlace param as null',
    setUp: () => placeRepository.mockGetPlaceById(
      result: createPlace(
        id: 'p1',
        name: 'place 1',
        coordinates: const Coordinates(50.1, 12.1),
      ),
    ),
    build: () => createCubit(),
    act: (cubit) async {
      await cubit.loadPlaceDetails('p1');
      cubit.resetSelectedPlace();
    },
    expect: () => [
      const MapState(
        status: MapStatus.loading,
      ),
      MapState(
        status: MapStatus.success,
        mode: MapMode.map,
        centerLocation: const Coordinates(50.1, 12.1),
        selectedPlace: createPlace(
          id: 'p1',
          name: 'place 1',
          coordinates: const Coordinates(50.1, 12.1),
        ),
      ),
      const MapState(
        status: MapStatus.success,
        mode: MapMode.map,
        centerLocation: Coordinates(50.1, 12.1),
        selectedPlace: null,
      ),
    ],
  );

  blocTest(
    'moveBackToUserLocation, '
    'should assign userLocation to displayedLocation and should set '
    'selectedPlace as null',
    build: () => createCubit(),
    setUp: () {
      locationService.mockGetCurrentLocation(
        result: const Coordinates(50.2, 25.4),
      );
      placeRepository.mockGetPlaceById(
        result: createPlace(
          id: 'p1',
          name: 'place 1',
          coordinates: const Coordinates(50.1, 12.1),
        ),
      );
    },
    act: (cubit) async {
      await cubit.initialize();
      await cubit.loadPlaceDetails('p1');
      cubit.moveBackToUserLocation();
    },
    expect: () => [
      const MapState(
        status: MapStatus.success,
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
      const MapState(
        status: MapStatus.loading,
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
      MapState(
        status: MapStatus.success,
        centerLocation: const Coordinates(50.1, 12.1),
        userLocation: const Coordinates(50.2, 25.4),
        selectedPlace: createPlace(
          id: 'p1',
          name: 'place 1',
          coordinates: const Coordinates(50.1, 12.1),
        ),
      ),
      const MapState(
        status: MapStatus.success,
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
    ],
  );
}
