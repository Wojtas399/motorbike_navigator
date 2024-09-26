import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class DrivePositionCreator {
  DrivePosition create({
    int order = 1,
    Coordinates coordinates = const Coordinates(0, 0),
    double elevation = 0,
    double speedInKmPerH = 0,
  }) =>
      DrivePosition(
        order: 1,
        coordinates: coordinates,
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );
}
