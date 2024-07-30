import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';

import '../creator/drive_creator.dart';
import '../creator/position_creator.dart';

void main() {
  final driveCreator = DriveCreator();
  final positionCreator = PositionCreator();

  test(
    'waypoints should represented as coordinates of positions',
    () {
      final List<Position> positions = [
        positionCreator.create(coordinates: const Coordinates(50, 18)),
        positionCreator.create(
          coordinates: const Coordinates(51, 19),
        ),
        positionCreator.create(
          coordinates: const Coordinates(52, 20),
        ),
      ];
      final Iterable<Coordinates> expectedWaypoints =
          positions.map((Position position) => position.coordinates);

      final drive = driveCreator.create(positions: positions);

      expect(drive.waypoints, expectedWaypoints);
    },
  );

  test(
    'avgSpeedInKmPerH should be calculated from list of positions',
    () {
      final List<Position> positions = [
        positionCreator.create(speedInKmPerH: 33.33),
        positionCreator.create(speedInKmPerH: 22.22),
        positionCreator.create(speedInKmPerH: 55.55),
      ];
      final double expectedAvgSpeed =
          positions.map((Position position) => position.speedInKmPerH).average;

      final drive = driveCreator.create(positions: positions);

      expect(drive.avgSpeedInKmPerH, expectedAvgSpeed);
    },
  );
}
