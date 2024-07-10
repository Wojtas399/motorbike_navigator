import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/drive_mapper.dart';
import 'package:motorbike_navigator/entity/drive.dart';

import '../../../creator/drive_dto_creator.dart';

class MockDriveMapper extends Mock implements DriveMapper {
  MockDriveMapper() {
    final driveDtoCreator = DriveDtoCreator();
    registerFallbackValue(
      driveDtoCreator.create(),
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
