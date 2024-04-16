import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to PlaceSuggestionDto object',
    () {
      const String id = 'ps1';
      const String name = 'place_suggestion 1';
      const String fullAddress = 'address';
      final Map<String, dynamic> json = {
        'mapbox_id': id,
        'name': name,
        'full_address': fullAddress,
      };
      const PlaceSuggestionDto expectedDto = PlaceSuggestionDto(
        id: id,
        name: name,
        fullAddress: fullAddress,
      );

      final PlaceSuggestionDto dto = PlaceSuggestionDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );
}
