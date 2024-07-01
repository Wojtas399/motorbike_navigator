import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates_dto.dart';

part 'drive_dto.freezed.dart';
part 'drive_dto.g.dart';

@freezed
class DriveDto with _$DriveDto {
  const factory DriveDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    required double distanceInKm,
    required int durationInSeconds,
    required double avgSpeedInKmPerH,
    required List<CoordinatesDto> waypoints,
  }) = _DriveDto;

  factory DriveDto.fromJson(Map<String, Object?> json) =>
      _$DriveDtoFromJson(json);

  factory DriveDto.fromIdAndJson(String id, Map<String, Object?> json) =>
      DriveDto.fromJson(json).copyWith(id: id);
}
