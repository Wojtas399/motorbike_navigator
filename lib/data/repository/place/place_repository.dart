import 'package:motorbike_navigator/data/repository/place/place_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../entity/place.dart';

part 'place_repository.g.dart';

abstract interface class PlaceRepository {
  Future<Place?> getPlaceById(String id);
}

@riverpod
PlaceRepository placeRepository(PlaceRepositoryRef ref) =>
    PlaceRepositoryImpl(ref);
