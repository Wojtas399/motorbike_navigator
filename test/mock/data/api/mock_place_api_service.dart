import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/api_service/place_api_service.dart';
import 'package:motorbike_navigator/data/dto/place_dto.dart';

class MockPlaceApiService extends Mock implements PlaceApiService {
  void mockFetchPlaceById({PlaceDto? result}) {
    when(
      () => fetchPlaceById(any()),
    ).thenAnswer((_) => Future.value(result));
  }
}
