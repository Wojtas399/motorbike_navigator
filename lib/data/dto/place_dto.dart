import 'package:equatable/equatable.dart';

import 'coordinates_dto.dart';

class PlaceDto extends Equatable {
  final String id;
  final String name;
  final CoordinatesDto coordinates;

  const PlaceDto({
    required this.id,
    required this.name,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        coordinates,
      ];

  factory PlaceDto.fromJson(Map<String, dynamic> json) => PlaceDto(
        id: json['properties']['mapbox_id'],
        name: json['properties']['name'],
        coordinates: CoordinatesDto.fromJson(json['geometry']),
      );
}
