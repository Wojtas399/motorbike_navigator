import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/dto/position_dto.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';

import '../../mock/data/mapper/mock_position_mapper.dart';

void main() {
  final positionMapper = MockPositionMapper();

  final DriveMapper mapper = DriveMapper(positionMapper);

  tearDown(() {
    reset(positionMapper);
  });

  test(
    'mapFromDto, '
    'should map DriveDto model to Drive model',
    () {
      const String id = 'd1';
      const String userId = 'u1';
      final DateTime startDateTime = DateTime(2024, 7, 10, 9, 28);
      const double distanceInKm = 10.21;
      const Duration duration = Duration(hours: 1, minutes: 20);
      const List<Position> positions = [
        Position(
          coordinates: Coordinates(50, 18),
          altitude: 100.22,
          speedInKmPerH: 22.22,
        ),
        Position(
          coordinates: Coordinates(51, 19),
          altitude: 1001.22,
          speedInKmPerH: 23.33,
        ),
      ];
      const List<PositionDto> positionDtos = [
        PositionDto(
          coordinates: CoordinatesDto(latitude: 50, longitude: 18),
          altitude: 100.22,
          speedInKmPerH: 22.22,
        ),
        PositionDto(
          coordinates: CoordinatesDto(latitude: 51, longitude: 19),
          altitude: 101.22,
          speedInKmPerH: 33.33,
        ),
      ];
      final DriveDto driveDto = DriveDto(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positionDtos,
      );
      final Drive expectedDrive = Drive(
        id: id,
        userId: userId,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );
      when(
        () => positionMapper.mapFromDto(positionDtos.first),
      ).thenReturn(positions.first);
      when(
        () => positionMapper.mapFromDto(positionDtos.last),
      ).thenReturn(positions.last);

      final Drive drive = mapper.mapFromDto(driveDto);

      expect(drive, expectedDrive);
    },
  );
}
