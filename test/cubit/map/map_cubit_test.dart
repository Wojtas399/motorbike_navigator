import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_cubit.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_state.dart';

import '../../creator/place_creator.dart';
import '../../mock/data/repository/mock_place_repository.dart';
import '../../mock/ui_service/mock_location_service.dart';

void main() {
  final locationService = MockLocationService();
  final placeRepository = MockPlaceRepository();

  MapCubit createCubit() => MapCubit(
        locationService,
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
    'loadPlaceDetails, '
    'should get place details from PlaceRepository, should change '
    'displayedLocation and selectedPlace params and should assign name of place '
    'to searchQuery param',
    setUp: () => placeRepository.mockGetPlaceById(
      result: createPlace(
        id: 'p1',
        name: 'place 1',
        coordinates: const Coordinates(50.1, 12.1),
      ),
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.loadPlaceDetails(
      placeId: 'p1',
      placeName: 'place name',
    ),
    expect: () => [
      const MapState(
        status: MapStatus.loading,
        searchQuery: 'place name',
      ),
      MapState(
        status: MapStatus.success,
        searchQuery: 'place name',
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
    'resetSelectedPlace, '
    'should set selectedPlace param as null and searchQuery param as empty '
    'string',
    setUp: () {
      placeRepository.mockGetPlaceById(
        result: createPlace(
          id: 'p1',
          name: 'place 1',
          coordinates: const Coordinates(50.1, 12.1),
        ),
      );
    },
    build: () => createCubit(),
    act: (cubit) async {
      await cubit.loadPlaceDetails(
        placeId: 'p1',
        placeName: 'place name',
      );
      cubit.resetSelectedPlace();
    },
    expect: () => [
      const MapState(
        status: MapStatus.loading,
        searchQuery: 'place name',
      ),
      MapState(
        status: MapStatus.success,
        searchQuery: 'place name',
        centerLocation: const Coordinates(50.1, 12.1),
        selectedPlace: createPlace(
          id: 'p1',
          name: 'place 1',
          coordinates: const Coordinates(50.1, 12.1),
        ),
      ),
      const MapState(
        status: MapStatus.success,
        searchQuery: '',
        centerLocation: Coordinates(50.1, 12.1),
        selectedPlace: null,
      ),
    ],
  );

  blocTest(
    'moveBackToUserLocation, '
    'should assign userLocation to displayedLocation, should set selectedPlace '
    'as null and searchQuery as empty string',
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
      await cubit.loadPlaceDetails(
        placeId: 'p1',
        placeName: 'place name',
      );
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
        searchQuery: 'place name',
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
      MapState(
        status: MapStatus.success,
        searchQuery: 'place name',
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
        searchQuery: '',
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
    ],
  );
}
