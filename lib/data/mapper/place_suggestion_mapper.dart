import '../../entity/place_suggestion.dart';
import '../dto/place_suggestion_dto.dart';

PlaceSuggestion mapPlaceSuggestionFromDto(PlaceSuggestionDto dto) =>
    PlaceSuggestion(
      id: dto.id,
      name: dto.name,
      fullAddress: dto.fullAddress,
    );
