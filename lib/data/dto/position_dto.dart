import 'package:freezed_annotation/freezed_annotation.dart';

import 'coordinates_dto.dart';

part 'position_dto.freezed.dart';
part 'position_dto.g.dart';

@freezed
class PositionDto with _$PositionDto {
  const factory PositionDto({
    @JsonKey(toJson: _mapCoordinatesToJson) required CoordinatesDto coordinates,
    required double altitude,
    required double speedInKmPerH,
  }) = _PositionDto;

  factory PositionDto.fromJson(Map<String, Object?> json) =>
      _$PositionDtoFromJson(json);
}

Map<String, Object?> _mapCoordinatesToJson(CoordinatesDto coordinatesDto) =>
    coordinatesDto.toJson();
