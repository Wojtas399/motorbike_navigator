import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route_geometry_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class RouteGeometryDto extends Equatable {
  @JsonKey(fromJson: _fromJson)
  final List<({double lat, double long})> coordinates;

  const RouteGeometryDto({
    required this.coordinates,
  });

  @override
  List<Object?> get props => [coordinates];

  factory RouteGeometryDto.fromJson(Map<String, dynamic> json) =>
      _$RouteGeometryDtoFromJson(json);

  static List<({double lat, double long})> _fromJson(List<List> coordinates) =>
      coordinates
          .map<({double lat, double long})>(
            (List coordinates) => (
              lat: coordinates.last,
              long: coordinates.first,
            ),
          )
          .toList();
}
