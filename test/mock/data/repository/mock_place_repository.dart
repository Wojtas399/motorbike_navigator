import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/place/place_repository.dart';
import 'package:motorbike_navigator/entity/place.dart';

class MockPlaceRepository extends Mock implements PlaceRepository {
  void mockGetPlaceById({Place? result}) {
    when(
      () => getPlaceById(any()),
    ).thenAnswer((_) => Future.value(result));
  }
}
