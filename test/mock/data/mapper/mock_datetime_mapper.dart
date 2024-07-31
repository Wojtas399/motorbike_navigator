import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/datetime_mapper.dart';

class MockDatetimeMapper extends Mock implements DateTimeMapper {
  void mockMapFromDto({
    required DateTime expectedDateTime,
  }) {
    when(() => mapFromDto(any())).thenReturn(expectedDateTime);
  }

  void mockMapToDto({
    required String expectedDateTimeStr,
  }) {
    when(() => mapToDto(any())).thenReturn(expectedDateTimeStr);
  }
}
