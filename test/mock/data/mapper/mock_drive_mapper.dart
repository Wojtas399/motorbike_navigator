import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/dto/drive_dto.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class MockDriveMapper extends Mock implements DriveMapper {
  MockDriveMapper() {
    registerFallbackValue(
      const DriveDto(
        distanceInKm: 1,
        durationInSeconds: 10000,
        avgSpeedInKmPerH: 1,
        waypoints: [],
      ),
    );
  }

  void mockMapFromDto({
    required Drive expectedDrive,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedDrive);
  }
}
