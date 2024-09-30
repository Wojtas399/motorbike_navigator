import 'package:injectable/injectable.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();

  DateTime getFirstDateOfTheWeek(DateTime dateTime) => DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day - (dateTime.weekday - 1),
      );

  DateTime getLastDateOfTheWeek(DateTime dateTime) => DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day + (DateTime.daysPerWeek - dateTime.weekday),
      );

  DateTime getFirstDateOfTheMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month);

  DateTime getLastDateOfTheMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month + 1).subtract(
        const Duration(days: 1),
      );

  DateTime getFirstDateOfTheYear(DateTime dateTime) => DateTime(dateTime.year);

  DateTime getLastDateOfTheYear(DateTime dateTime) =>
      DateTime(dateTime.year + 1).subtract(
        const Duration(milliseconds: 1),
      );

  PartOfTheDay getPartOfTheDay(DateTime dateTime) {
    final hour = dateTime.hour;
    return hour <= 5
        ? PartOfTheDay.night
        : hour <= 12
            ? PartOfTheDay.morning
            : hour <= 18
                ? PartOfTheDay.afternoon
                : hour <= 23
                    ? PartOfTheDay.evening
                    : PartOfTheDay.night;
  }

  bool isDateFromRange({
    required DateTime date,
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  }) {
    final bool isGreaterOrEqualToFirstDateOfRange =
        date.isAfter(firstDateOfRange) || areDatesEqual(date, firstDateOfRange);
    final bool isLowerOrEqualToLastDateOfRange =
        date.isBefore(lastDateOfRange) || areDatesEqual(date, lastDateOfRange);
    return isGreaterOrEqualToFirstDateOfRange &&
        isLowerOrEqualToLastDateOfRange;
  }

  bool areDatesEqual(DateTime date1, DateTime date2) =>
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;

  bool areMonthsEqual(DateTime date1, DateTime date2) =>
      date1.year == date2.year && date1.month == date2.month;

  int calculateNumberOfDaysBetweenDatesInclusively(DateTime from, DateTime to) {
    final correctedFrom = DateTime(from.year, from.month, from.day);
    final correctedTo = DateTime(to.year, to.month, to.day, 23, 59);
    return (correctedTo.difference(correctedFrom).inHours / 24).round();
  }
}

enum PartOfTheDay {
  morning,
  afternoon,
  evening,
  night,
}
