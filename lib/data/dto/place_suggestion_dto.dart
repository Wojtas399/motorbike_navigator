import 'package:equatable/equatable.dart';
import 'package:mapbox_search/mapbox_search.dart';

class PlaceSuggestionDto extends Equatable {
  final String id;
  final String name;
  final String? address;

  const PlaceSuggestionDto({
    required this.id,
    required this.name,
    this.address,
  });

  @override
  List<Object?> get props => [id, name, address];

  factory PlaceSuggestionDto.fromMapboxSuggestion(Suggestion suggestion) =>
      PlaceSuggestionDto(
        id: suggestion.mapboxId,
        name: suggestion.name,
        address: suggestion.address,
      );
}
