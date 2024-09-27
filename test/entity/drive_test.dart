import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';

import '../creator/drive_creator.dart';
import '../creator/drive_position_creator.dart';

void main() {
  test(
    'waypoints getter should return list of coordinates',
    () {
      final List<DrivePosition> positions = [
        const DrivePositionCreator(latitude: 50, longitude: 18).createEntity(),
        const DrivePositionCreator(latitude: 51, longitude: 19).createEntity(),
        const DrivePositionCreator(latitude: 52, longitude: 20).createEntity(),
      ];
      final Iterable<Coordinates> expectedWaypoints =
          positions.map((Position position) => position.coordinates);

      final drive = DriveCreator(positions: positions).createEntity();

      expect(drive.waypoints, expectedWaypoints);
    },
  );

  test(
    'elevationPoints getter should return list of elevation points',
    () {
      final List<DrivePosition> positions = [
        const DrivePositionCreator(elevation: 155.5).createEntity(),
        const DrivePositionCreator(elevation: 165.5).createEntity(),
        const DrivePositionCreator(elevation: 175.5).createEntity(),
        const DrivePositionCreator(elevation: 185.5).createEntity(),
      ];
      final Iterable<double> expectedAltitudePoints = [
        positions.first.elevation,
        positions[1].elevation,
        positions[2].elevation,
        positions.last.elevation,
      ];

      final drive = DriveCreator(positions: positions).createEntity();

      expect(drive.elevationPoints, expectedAltitudePoints);
    },
  );

  test(
    'avgSpeedInKmPerH getter should return average speed calculated from list '
    'of positions',
    () {
      final List<DrivePosition> positions = [
        const DrivePositionCreator(speedInKmPerH: 33.33).createEntity(),
        const DrivePositionCreator(speedInKmPerH: 22.22).createEntity(),
        const DrivePositionCreator(speedInKmPerH: 55.55).createEntity(),
      ];
      final double expectedAvgSpeed = (positions.first.speedInKmPerH +
              positions[1].speedInKmPerH +
              positions.last.speedInKmPerH) /
          3;

      final drive = DriveCreator(positions: positions).createEntity();

      expect(drive.avgSpeedInKmPerH, expectedAvgSpeed);
    },
  );

  test(
    'maxSpeedInKmPerH getter should return max speed from list of position',
    () {
      final List<DrivePosition> positions = [
        const DrivePositionCreator(speedInKmPerH: 33.33).createEntity(),
        const DrivePositionCreator(speedInKmPerH: 22.22).createEntity(),
        const DrivePositionCreator(speedInKmPerH: 55.55).createEntity(),
      ];
      const double expectedMaxSpeed = 55.55;

      final drive = DriveCreator(positions: positions).createEntity();

      expect(drive.maxSpeedInKmPerH, expectedMaxSpeed);
    },
  );

  test(
    'maxElevation getter should return max elevation from list of position',
    () {
      final List<DrivePosition> positions = [
        const DrivePositionCreator(elevation: 105.2).createEntity(),
        const DrivePositionCreator(elevation: 122.22).createEntity(),
        const DrivePositionCreator(elevation: 95.55).createEntity(),
      ];
      const double expectedMaxElevation = 122.22;

      final drive = DriveCreator(positions: positions).createEntity();

      expect(drive.maxElevation, expectedMaxElevation);
    },
  );

  test(
    'minElevation getter should return min elevation from list of position',
    () {
      final List<DrivePosition> positions = [
        const DrivePositionCreator(elevation: 105.2).createEntity(),
        const DrivePositionCreator(elevation: 122.22).createEntity(),
        const DrivePositionCreator(elevation: 95.55).createEntity(),
      ];
      const double expectedMinElevation = 95.55;

      final drive = DriveCreator(positions: positions).createEntity();

      expect(drive.minElevation, expectedMinElevation);
    },
  );
}
