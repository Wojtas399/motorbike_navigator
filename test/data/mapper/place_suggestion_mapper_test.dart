import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';
import 'package:motorbike_navigator/data/mapper/place_suggestion_mapper.dart';
import 'package:motorbike_navigator/entity/place_suggestion.dart';

void main() {
  test(
    'mapPlaceSuggestionFromDto, '
    'should map PlaceSuggestionDto object to PlaceSuggestion object',
    () {
      const String id = 'ps1';
      const String name = 'place 1';
      const String fullAddress = 'address';
      const PlaceSuggestionDto dto = PlaceSuggestionDto(
        id: id,
        name: name,
        fullAddress: fullAddress,
      );
      const PlaceSuggestion expectedObject = PlaceSuggestion(
        id: id,
        name: name,
        fullAddress: fullAddress,
      );

      final PlaceSuggestion object = mapPlaceSuggestionFromDto(dto);

      expect(object, expectedObject);
    },
  );
}
