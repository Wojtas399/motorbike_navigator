import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/drive.dart';

import '../../../creator/drive_creator.dart';

class MockDriveMapper extends Mock implements DriveMapper {
  MockDriveMapper() {
    registerFallbackValue(
      DriveCreator().createSqliteDto(),
    );
  }

  void mockMapFromDto({
    required Drive expectedDrive,
  }) {
    when(
      () => mapFromDto(
        driveDto: any(named: 'driveDto'),
        positions: any(named: 'positions'),
      ),
    ).thenReturn(expectedDrive);
  }
}
