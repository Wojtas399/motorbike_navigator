import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/drive.dart';

import '../../../creator/drive_sqlite_dto_creator.dart';

class MockDriveMapper extends Mock implements DriveMapper {
  MockDriveMapper() {
    final driveSqliteDtoCreator = DriveSqliteDtoCreator();
    registerFallbackValue(
      driveSqliteDtoCreator.create(),
    );
  }

  void mockMapFromDto({
    required Drive expectedDrive,
  }) {
    when(
      () => mapFromDto(
        driveDto: any(named: 'driveDto'),
        positionDtos: any(named: 'positionDtos'),
      ),
    ).thenReturn(expectedDrive);
  }
}
