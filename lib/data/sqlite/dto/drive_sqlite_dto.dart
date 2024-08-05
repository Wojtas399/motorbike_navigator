import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../dependency_injection.dart';
import '../../mapper/datetime_mapper.dart';

part 'drive_sqlite_dto.freezed.dart';
part 'drive_sqlite_dto.g.dart';

@freezed
class DriveSqliteDto with _$DriveSqliteDto {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory DriveSqliteDto({
    @JsonKey(includeToJson: false) @Default(0) int id,
    @JsonKey(
      fromJson: _mapStartDateTimeFromString,
      toJson: _mapStartDateTimeToString,
    )
    required DateTime startDateTime,
    @JsonKey(name: 'distance') required double distanceInKm,
    required Duration duration,
  }) = _DriveSqliteDto;

  factory DriveSqliteDto.fromJson(Map<String, Object?> json) =>
      _$DriveSqliteDtoFromJson(json);
}

DateTime _mapStartDateTimeFromString(String startDateTime) =>
    getIt.get<DateTimeMapper>().mapFromDto(startDateTime);

String _mapStartDateTimeToString(DateTime startDateTime) =>
    getIt.get<DateTimeMapper>().mapToDto(startDateTime);
