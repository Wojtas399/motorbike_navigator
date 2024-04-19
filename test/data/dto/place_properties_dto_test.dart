import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_properties_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to PlacePropertiesDto object',
    () {
      const String id = 'p1';
      const String name = 'place';
      const String fullAddress = 'full address';
      final Map<String, dynamic> json = {
        'mapbox_id': id,
        'name': name,
        'full_address': fullAddress,
      };
      const PlacePropertiesDto expectedPlacePropertiesDto = PlacePropertiesDto(
        id: id,
        name: name,
        fullAddress: fullAddress,
      );

      final PlacePropertiesDto placePropertiesDto =
          PlacePropertiesDto.fromJson(json);

      expect(placePropertiesDto, expectedPlacePropertiesDto);
    },
  );
}
