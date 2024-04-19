import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_geometry_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PlaceGeometryDto extends Equatable {
  @JsonKey(fromJson: _fromJson)
  final ({double lat, double long}) coordinates;

  const PlaceGeometryDto({
    required this.coordinates,
  });

  @override
  List<Object?> get props => [coordinates];

  factory PlaceGeometryDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceGeometryDtoFromJson(json);

  static ({double lat, double long}) _fromJson(List coordinates) => (
        lat: coordinates.last,
        long: coordinates.first,
      );
}
