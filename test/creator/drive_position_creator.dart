import 'package:motorbike_navigator/data/local_db/dto/drive_position_sqlite_dto.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class DrivePositionCreator {
  final int driveId;
  final int order;
  final double latitude;
  final double longitude;
  final double elevation;
  final double speedInKmPerH;

  const DrivePositionCreator({
    this.driveId = 0,
    this.order = 1,
    this.latitude = 0,
    this.longitude = 0,
    this.elevation = 0,
    this.speedInKmPerH = 0,
  });

  DrivePosition createEntity() => DrivePosition(
        order: 1,
        coordinates: Coordinates(latitude, longitude),
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );

  DrivePositionSqliteDto createSqliteDto() => DrivePositionSqliteDto(
        driveId: driveId,
        order: order,
        latitude: latitude,
        longitude: longitude,
        elevation: elevation,
        speedInKmPerH: speedInKmPerH,
      );
}
