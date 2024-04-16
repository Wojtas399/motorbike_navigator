import 'package:equatable/equatable.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:mapbox_search/models/retrieve_response.dart';
import 'package:motorbike_navigator/data/dto/coordinates_dto.dart';

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

  factory PlaceDto.fromMapboxFeature({
    required String id,
    required Feature feature,
  }) =>
      PlaceDto(
        id: id,
        name: feature.properties.wikidata ?? '',
        coordinates: CoordinatesDto.fromMapboxLocation(
          feature.geometry.coordinates,
        ),
      );
}
