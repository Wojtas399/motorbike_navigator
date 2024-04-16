import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../entity/place.dart';
import 'place_repository_impl.dart';

part 'place_repository.g.dart';

abstract interface class PlaceRepository {
  Future<Place?> getPlaceById(String id);
}

@riverpod
PlaceRepository placeRepository(PlaceRepositoryRef ref) =>
    PlaceRepositoryImpl(ref);
