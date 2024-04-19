import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';
import 'package:motorbike_navigator/data/repository/place/place_repository_impl.dart';
import 'package:motorbike_navigator/entity/place.dart';

import '../../creator/place_creator.dart';
import '../../creator/place_dto_creator.dart';
import '../../mock/data/api/mock_place_api_service.dart';

void main() {
  final placeApiService = MockPlaceApiService();

  test(
    'getPlaceById, '
    'place already exists in repo, '
    'should return place existing in repo',
    () async {
      final Place expectedPlace = createPlace(id: 'p1', name: 'place 1');
      final List<Place> existingPlaces = [
        expectedPlace,
        createPlace(id: 'p2', name: 'place 2'),
        createPlace(id: 'p3', name: 'place 3'),
      ];
      final repositoryImpl = PlaceRepositoryImpl(placeApiService);
      repositoryImpl.setEntities(existingPlaces);

      final Place? place = await repositoryImpl.getPlaceById('p1');

      expect(place, expectedPlace);
    },
  );

  test(
    'getPlaceById, '
    'place does not exist in repo, '
    'should fetch place from db, add it to repo and return it',
    () async {
      const String placeId = 'p1';
      PlaceDto expectedPlaceDto = createPlaceDto(id: placeId, name: 'place 1');
      final Place expectedPlace = createPlace(id: placeId, name: 'place 1');
      final List<Place> existingPlaces = [
        createPlace(id: 'p2', name: 'place 2'),
        createPlace(id: 'p3', name: 'place 3'),
      ];
      placeApiService.mockFetchPlaceById(result: expectedPlaceDto);
      final repositoryImpl = PlaceRepositoryImpl(placeApiService);
      repositoryImpl.setEntities(existingPlaces);

      final Place? place = await repositoryImpl.getPlaceById(placeId);

      expect(place, expectedPlace);
      expect(
        await repositoryImpl.repositoryState$.first,
        [...existingPlaces, expectedPlace],
      );
      verify(
        () => placeApiService.fetchPlaceById(placeId),
      ).called(1);
    },
  );
}
