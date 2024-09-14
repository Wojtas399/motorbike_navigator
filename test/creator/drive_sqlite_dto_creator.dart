import 'package:motorbike_navigator/data/dto/position_dto.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';

class DriveSqliteDtoCreator {
  DriveSqliteDto create({
    int id = 0,
    String title = '',
    DateTime? startDateTime,
    double distanceInKm = 0,
    Duration duration = const Duration(seconds: 0),
    List<PositionDto> positions = const [],
  }) =>
      DriveSqliteDto(
        id: id,
        title: title,
        startDateTime: startDateTime ?? DateTime(2024),
        distanceInKm: distanceInKm,
        duration: duration,
      );
}
