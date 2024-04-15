import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_search/mapbox_search.dart';
import 'package:motorbike_navigator/data/dto/place_suggestion_dto.dart';

void main() {
  test(
    'fromMapboxSuggestion, '
    'should map Suggestion object from mapbox plugin to PlaceSuggestionDto object',
    () {
      const String id = 'ps1';
      const String name = 'place 1';
      const String address = 'address';
      final Suggestion suggestion = Suggestion(
        name: name,
        mapboxId: id,
        featureType: '',
        address: address,
        fullAddress: null,
        placeFormatted: '',
        context: Context(
          country: Country(
            id: id,
            name: name,
            countryCode: '',
            countryCodeAlpha3: '',
          ),
          postcode: Place(name: ''),
          place: Place(name: ''),
        ),
        language: '',
        maki: null,
      );
      const PlaceSuggestionDto expectedDto = PlaceSuggestionDto(
        id: id,
        name: name,
        address: address,
      );

      final PlaceSuggestionDto dto =
          PlaceSuggestionDto.fromMapboxSuggestion(suggestion);

      expect(dto, expectedDto);
    },
  );
}
