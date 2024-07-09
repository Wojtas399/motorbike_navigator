import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinates_dto.freezed.dart';
part 'coordinates_dto.g.dart';

@freezed
class CoordinatesDto with _$CoordinatesDto {
  const factory CoordinatesDto({
    required double latitude,
    required double longitude,
  }) = _CoordinatesDto;

  factory CoordinatesDto.fromJson(Map<String, Object?> json) =>
      _$CoordinatesDtoFromJson(json);
}
