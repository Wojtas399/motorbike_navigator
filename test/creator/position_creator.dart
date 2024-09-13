import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';

class PositionCreator {
  Position create({
    Coordinates coordinates = const Coordinates(0, 0),
    double elevation = 0,
    double speedInKmPerH = 0,
  }) =>
      Position(
        coordinates: coordinates,
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );
}
