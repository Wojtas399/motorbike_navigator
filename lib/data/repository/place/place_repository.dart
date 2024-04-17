import '../../../entity/place.dart';

abstract interface class PlaceRepository {
  Future<Place?> getPlaceById(String id);
}
