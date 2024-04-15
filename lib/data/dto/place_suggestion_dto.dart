import 'package:equatable/equatable.dart';
import 'package:mapbox_search/mapbox_search.dart';

class PlaceSuggestionDto extends Equatable {
  final String id;
  final String name;
  final String? fullAddress;

  const PlaceSuggestionDto({
    required this.id,
    required this.name,
    this.fullAddress,
  });

  @override
  List<Object?> get props => [id, name, fullAddress];

  factory PlaceSuggestionDto.fromMapboxSuggestion(Suggestion suggestion) =>
      PlaceSuggestionDto(
        id: suggestion.mapboxId,
        name: suggestion.name,
        fullAddress: suggestion.fullAddress,
      );
}
