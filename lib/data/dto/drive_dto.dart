import 'package:freezed_annotation/freezed_annotation.dart';

import 'position_dto.dart';

part 'drive_dto.freezed.dart';
part 'drive_dto.g.dart';

@freezed
class DriveDto with _$DriveDto {
  const factory DriveDto({
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String id,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default('')
    String userId,
    required DateTime startDateTime,
    required double distanceInKm,
    required Duration duration,
    required double avgSpeedInKmPerH,
    @JsonKey(toJson: _mapPositionsToJsons) required List<PositionDto> positions,
  }) = _DriveDto;

  factory DriveDto.fromJson(Map<String, Object?> json) =>
      _$DriveDtoFromJson(json);

  factory DriveDto.fromFirebaseFirestore({
    required String driveId,
    required String userId,
    required Map<String, Object?> json,
  }) =>
      DriveDto.fromJson(json).copyWith(
        id: driveId,
        userId: userId,
      );
}

List<Map<String, Object?>> _mapPositionsToJsons(
  List<PositionDto> positionDtos,
) =>
    positionDtos.map((positionDto) => positionDto.toJson()).toList();
