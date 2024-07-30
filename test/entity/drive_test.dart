import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/position.dart';

import '../creator/drive_creator.dart';
import '../creator/position_creator.dart';

void main() {
  final driveCreator = DriveCreator();
  final positionCreator = PositionCreator();

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

      final drive = driveCreator.create(
        positions: positions,
      );

      expect(drive.avgSpeedInKmPerH, expectedAvgSpeed);
    },
  );
}
