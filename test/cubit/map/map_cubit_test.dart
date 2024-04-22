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
    'should get current location from LocationService',
    setUp: () => locationService.mockGetCurrentLocation(
      result: const Coordinates(50.2, 25.4),
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const MapState(
        status: MapStatus.loading,
      ),
      const MapState(
        status: MapStatus.success,
        currentLocation: Coordinates(50.2, 25.4),
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
    'should get place details from PlaceRepository and should set mode to map',
    setUp: () => placeRepository.mockGetPlaceById(
      result: createPlace(id: 'p1', name: 'place 1'),
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
        selectedPlace: createPlace(id: 'p1', name: 'place 1'),
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
      result: createPlace(id: 'p1', name: 'place 1'),
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
        selectedPlace: createPlace(id: 'p1', name: 'place 1'),
      ),
      const MapState(
        status: MapStatus.success,
        mode: MapMode.map,
        selectedPlace: null,
      ),
    ],
  );
}
