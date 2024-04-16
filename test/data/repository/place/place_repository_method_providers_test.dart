import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/repository/place/place_repository.dart';
import 'package:motorbike_navigator/data/repository/place/place_repository_method_providers.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/place.dart';

import '../../../mock/data/repository/mock_place_repository.dart';

void main() {
  test(
    'getPlaceById, '
    'should return place got directly from PlaceRepository',
    () async {
      const String id = 'p1';
      const Place expectedPlace = Place(
        id: id,
        name: 'place',
        coordinates: Coordinates(50.5, 60.1),
      );
      final placeRepository = MockPlaceRepository();
      placeRepository.mockGetPlaceById(result: expectedPlace);
      final container = ProviderContainer(
        overrides: [
          placeRepositoryProvider.overrideWithValue(placeRepository),
        ],
      );

      final Place? place = await container.read(
        getPlaceByIdProvider(id).future,
      );

      expect(place, expectedPlace);
    },
  );
}
