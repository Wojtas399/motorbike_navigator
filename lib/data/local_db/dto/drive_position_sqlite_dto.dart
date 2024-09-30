import 'package:freezed_annotation/freezed_annotation.dart';

part 'drive_position_sqlite_dto.freezed.dart';
part 'drive_position_sqlite_dto.g.dart';

@freezed
class DrivePositionSqliteDto with _$DrivePositionSqliteDto {
  const factory DrivePositionSqliteDto({
    @JsonKey(includeToJson: false) @Default(0) int id,
    @JsonKey(name: 'drive_id') required int driveId,
    @JsonKey(name: 'position_order') required int order,
    required double latitude,
    required double longitude,
    required double elevation,
    @JsonKey(name: 'speed') required double speedInKmPerH,
  }) = _DrivePositionSqliteDto;

  factory DrivePositionSqliteDto.fromJson(Map<String, Object?> json) =>
      _$DrivePositionSqliteDtoFromJson(json);
}
