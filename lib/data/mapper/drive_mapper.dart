import 'package:injectable/injectable.dart';

import '../../entity/coordinates.dart';
import '../../entity/drive.dart';
import '../dto/drive_dto.dart';
import 'mapper.dart';

@injectable
class DriveMapper extends Mapper<Drive, DriveDto> {
  const DriveMapper();

  @override
  Drive mapFromDto(DriveDto dto) => Drive(
        id: dto.id,
        userId: dto.userId,
        distanceInKm: dto.distanceInKm,
        durationInSeconds: dto.durationInSeconds,
        avgSpeedInKmPerH: dto.avgSpeedInKmPerH,
        waypoints: dto.waypoints
            .map(
              (coordinates) => Coordinates(
                coordinates.latitude,
                coordinates.longitude,
              ),
            )
            .toList(),
      );
}
