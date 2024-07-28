import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/service/date_service.dart';

class MockDateService extends Mock implements DateService {
  void mockGetNow({
    required DateTime expectedNow,
  }) {
    when(getNow).thenReturn(expectedNow);
  }

  void mockGetFirstDateOfTheWeek({
    required DateTime expectedFirstDateOfTheWeek,
  }) {
    when(
      () => getFirstDateOfTheWeek(any()),
    ).thenReturn(expectedFirstDateOfTheWeek);
  }

  void mockGetLastDateOfTheWeek({
    required DateTime expectedLastDateOfTheWeek,
  }) {
    when(
      () => getLastDateOfTheWeek(any()),
    ).thenReturn(expectedLastDateOfTheWeek);
  }

  void mockGetFirstDateOfTheMonth({
    required DateTime expectedFirstDateOfTheMonth,
  }) {
    when(
      () => getFirstDateOfTheMonth(any()),
    ).thenReturn(expectedFirstDateOfTheMonth);
  }

  void mockGetLastDateOfTheMonth({
    required DateTime expectedLastDateOfTheMonth,
  }) {
    when(
      () => getLastDateOfTheMonth(any()),
    ).thenReturn(expectedLastDateOfTheMonth);
  }

  void mockGetFirstDateOfTheYear({
    required DateTime expectedFirstDateOfTheYear,
  }) {
    when(
      () => getFirstDateOfTheYear(any()),
    ).thenReturn(expectedFirstDateOfTheYear);
  }

  void mockGetLastDateOfTheYear({
    required DateTime expectedLastDateOfTheYear,
  }) {
    when(
      () => getLastDateOfTheYear(any()),
    ).thenReturn(expectedLastDateOfTheYear);
  }

  void mockIsDateFromRange({
    required bool expectedAnswer,
  }) {
    when(
      () => isDateFromRange(
        date: any(named: 'date'),
        firstDateOfRange: any(named: 'firstDateOfRange'),
        lastDateOfRange: any(named: 'lastDateOfRange'),
      ),
    ).thenReturn(expectedAnswer);
  }

  void mockAreDatesEqual({
    required bool expectedAnswer,
  }) {
    when(() => areDatesEqual(any(), any())).thenReturn(expectedAnswer);
  }

  void mockAreMonthsEqual({
    required bool expectedAnswer,
  }) {
    when(
      () => areMonthsEqual(any(), any()),
    ).thenReturn(expectedAnswer);
  }

  void mockCalculateNumberOfDaysBetweenDatesInclusively({
    required int expectedNumberOfDays,
  }) {
    when(
      () => calculateNumberOfDaysBetweenDatesInclusively(
        any(),
        any(),
      ),
    ).thenReturn(expectedNumberOfDays);
  }
}
