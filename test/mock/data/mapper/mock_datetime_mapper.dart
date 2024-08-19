import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/mapper/datetime_mapper.dart';

class MockDatetimeMapper extends Mock implements DateTimeMapper {
  void mockMapFromDateAndTimeStrings({
    required DateTime expectedDateTime,
  }) {
    when(
      () => mapFromDateAndTimeStrings(any(), any()),
    ).thenReturn(expectedDateTime);
  }

  void mockMapToDateString({
    required String expectedDateStr,
  }) {
    when(
      () => mapToDateString(any()),
    ).thenReturn(expectedDateStr);
  }

  void mockMapToTimeString({
    required String expectedTimeStr,
  }) {
    when(
      () => mapToTimeString(any()),
    ).thenReturn(expectedTimeStr);
  }
}
