import 'package:injectable/injectable.dart';

import '../../entity/drive.dart';
import '../dto/drive_dto.dart';
import 'mapper.dart';
import 'position_mapper.dart';

@injectable
class DriveMapper extends Mapper<Drive, DriveDto> {
  final PositionMapper _positionMapper;

  const DriveMapper(this._positionMapper);

  @override
  Drive mapFromDto(DriveDto dto) => Drive(
        id: dto.id,
        startDateTime: dto.startDateTime,
        distanceInKm: dto.distanceInKm,
        duration: dto.duration,
        positions: dto.positions.map(_positionMapper.mapFromDto).toList(),
      );
}
