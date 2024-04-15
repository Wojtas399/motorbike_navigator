import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';

PlaceSuggestion mapPlaceSuggestionFromDto(PlaceSuggestionDto dto) =>
    PlaceSuggestion(
      id: dto.id,
      name: dto.name,
      fullAddress: dto.fullAddress,
    );
