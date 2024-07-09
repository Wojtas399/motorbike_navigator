import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/place_mapper.dart';
import 'package:motorbike_navigator/entity/place.dart';

import '../../../creator/place_dto_creator.dart';

class MockPlaceMapper extends Mock implements PlaceMapper {
  MockPlaceMapper() {
    final placeDtoCreator = PlaceDtoCreator();
    registerFallbackValue(placeDtoCreator.create());
  }

  void mockMapFromDto({
    required Place expectedPlace,
  }) {
    when(
      () => mapFromDto(any()),
    ).thenReturn(expectedPlace);
  }
}
