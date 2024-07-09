import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/place.dart';

class PlaceCreator {
  Place create({
    String id = '',
    String name = '',
    String fullAddress = '',
    Coordinates coordinates = const Coordinates(0, 0),
  }) =>
      Place(
        id: id,
        name: name,
        fullAddress: fullAddress,
        coordinates: coordinates,
      );
}
