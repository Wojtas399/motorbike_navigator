import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api/place_api_service.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';
import 'package:motorbike_navigator/data/dto/place_geometry_dto.dart';
import 'package:motorbike_navigator/data/dto/place_properties_dto.dart';
import 'package:motorbike_navigator/data/repository/place/place_repository_impl.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/place.dart';

import '../../../mock/data/api/mock_place_api_service.dart';

void main() {
  final placeApiService = MockPlaceApiService();

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      overrides: [
        placeApiServiceProvider.overrideWithValue(placeApiService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'getPlaceById, '
    'place already exists in repo, '
    'should return place existing in repo',
    () async {
      const Place expectedPlace = Place(
        id: 'p1',
        name: 'place 1',
        coordinates: Coordinates(50.5, 45.5),
      );
      final List<Place> existingPlaces = [
        expectedPlace,
        const Place(
          id: 'p2',
          name: 'place 2',
          coordinates: Coordinates(44.4, 46.5),
        ),
        const Place(
          id: 'p3',
          name: 'place 3',
          coordinates: Coordinates(49.4, 41.15),
        ),
      ];
      final repositoryImplProvider = AutoDisposeProvider(
        (ref) => PlaceRepositoryImpl(ref, initialState: existingPlaces),
      );
      final container = createContainer();

      final Place? place =
          await container.read(repositoryImplProvider).getPlaceById('p1');

      expect(place, expectedPlace);
    },
  );

  test(
    'getPlaceById, '
    'place does not exist in repo, '
    'should fetch place from db, add it to repo and return it',
    () async {
      const String placeId = 'p1';
      const PlaceDto expectedPlaceDto = PlaceDto(
        properties: PlacePropertiesDto(
          mapboxId: placeId,
          name: 'place 1',
        ),
        geometry: PlaceGeometryDto(
          coordinates: (lat: 50.5, long: 45.5),
        ),
      );
      const Place expectedPlace = Place(
        id: placeId,
        name: 'place 1',
        coordinates: Coordinates(50.5, 45.5),
      );
      final List<Place> existingPlaces = [
        const Place(
          id: 'p2',
          name: 'place 2',
          coordinates: Coordinates(44.4, 46.5),
        ),
        const Place(
          id: 'p3',
          name: 'place 3',
          coordinates: Coordinates(49.4, 41.15),
        ),
      ];
      placeApiService.mockFetchPlaceById(result: expectedPlaceDto);
      final repositoryImplProvider = AutoDisposeProvider(
        (ref) => PlaceRepositoryImpl(ref, initialState: existingPlaces),
      );
      final container = createContainer();

      final Place? place =
          await container.read(repositoryImplProvider).getPlaceById(placeId);

      expect(place, expectedPlace);
      expect(
        await container.read(repositoryImplProvider).repositoryState$.first,
        [
          ...existingPlaces,
          expectedPlace,
        ],
      );
      verify(
        () => placeApiService.fetchPlaceById(placeId),
      ).called(1);
    },
  );
}
