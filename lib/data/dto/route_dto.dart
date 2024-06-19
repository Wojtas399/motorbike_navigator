import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'route_geometry_dto.dart';

part 'route_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class RouteDto extends Equatable {
  final double distance;
  final RouteGeometryDto geometry;

  const RouteDto({
    required this.distance,
    required this.geometry,
  });

  @override
  List<Object?> get props => [distance, geometry];

  factory RouteDto.fromJson(Map<String, dynamic> json) =>
      _$RouteDtoFromJson(json);
}
