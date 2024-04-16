import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'place_geometry_dto.dart';
import 'place_properties_dto.dart';

part 'place_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PlaceDto extends Equatable {
  final PlacePropertiesDto properties;
  final PlaceGeometryDto geometry;

  const PlaceDto({
    required this.properties,
    required this.geometry,
  });

  @override
  List<Object?> get props => [properties, geometry];

  factory PlaceDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceDtoFromJson(json);
}
