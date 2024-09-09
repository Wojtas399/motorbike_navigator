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
    'waypoints getter should return list of coordinates',
    () {
      final List<Position> positions = [
        positionCreator.create(
          coordinates: const Coordinates(50, 18),
        ),
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
    'altitudePoints getter should return list of altitude points',
    () {
      final List<Position> positions = [
        positionCreator.create(altitude: 155.5),
        positionCreator.create(altitude: 165.5),
        positionCreator.create(altitude: 175.5),
        positionCreator.create(altitude: 185.5),
      ];
      final Iterable<double> expectedAltitudePoints = [
        positions.first.altitude,
        positions[1].altitude,
        positions[2].altitude,
        positions.last.altitude,
      ];

      final drive = driveCreator.create(positions: positions);

      expect(drive.altitudePoints, expectedAltitudePoints);
    },
  );

  test(
    'avgSpeedInKmPerH getter should return average speed calculated from list '
    'of positions',
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
