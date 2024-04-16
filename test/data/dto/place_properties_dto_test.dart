import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/data/dto/place_properties_dto.dart';

void main() {
  test(
    'fromJson, '
    'should map json object to PlacePropertiesDto object',
    () {
      const String id = 'p1';
      const String name = 'place';
      final Map<String, dynamic> json = {
        'mapbox_id': id,
        'name': name,
      };
      const PlacePropertiesDto expectedPlacePropertiesDto = PlacePropertiesDto(
        id: id,
        name: name,
      );

      final PlacePropertiesDto placePropertiesDto =
          PlacePropertiesDto.fromJson(json);

      expect(placePropertiesDto, expectedPlacePropertiesDto);
    },
  );
}
