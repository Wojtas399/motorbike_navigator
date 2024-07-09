import '../../entity/coordinates.dart';
import '../../entity/drive.dart';
import '../dto/coordinates_dto.dart';
import '../dto/drive_dto.dart';

Drive mapDriveFromDto(DriveDto driveDto) => Drive(
      id: driveDto.id,
      userId: driveDto.userId,
      distanceInKm: driveDto.distanceInKm,
      durationInSeconds: driveDto.durationInSeconds,
      avgSpeedInKmPerH: driveDto.avgSpeedInKmPerH,
      waypoints: driveDto.waypoints
          .map(
            (coordinates) => Coordinates(
              coordinates.lat,
              coordinates.long,
            ),
          )
          .toList(),
    );

DriveDto mapDriveToDto(Drive drive) => DriveDto(
      id: drive.id,
      userId: drive.userId,
      distanceInKm: drive.distanceInKm,
      durationInSeconds: drive.durationInSeconds,
      avgSpeedInKmPerH: drive.avgSpeedInKmPerH,
      waypoints: drive.waypoints
          .map(
            (coordinates) => CoordinatesDto(
              lat: coordinates.latitude,
              long: coordinates.longitude,
            ),
          )
          .toList(),
    );
