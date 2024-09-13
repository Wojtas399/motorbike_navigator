import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_sqlite_dto.freezed.dart';
part 'position_sqlite_dto.g.dart';

@freezed
class PositionSqliteDto with _$PositionSqliteDto {
  const factory PositionSqliteDto({
    @JsonKey(includeToJson: false) @Default(0) int id,
    @JsonKey(name: 'drive_id') required int driveId,
    @JsonKey(name: 'position_order') required int order,
    required double latitude,
    required double longitude,
    required double elevation,
    @JsonKey(name: 'speed') required double speedInKmPerH,
  }) = _PositionSqliteDto;

  factory PositionSqliteDto.fromJson(Map<String, Object?> json) =>
      _$PositionSqliteDtoFromJson(json);
}
