import 'package:injectable/injectable.dart';

@injectable
class DateTimeService {
  DateTime getNow() => DateTime.now();

  DateTime getFirstDateTimeOfTheWeek(DateTime dateTime) => DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day - (dateTime.weekday - 1),
      );

  DateTime getLastDateTimeOfTheWeek(DateTime dateTime) => DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day + (DateTime.daysPerWeek - dateTime.weekday) + 1,
      ).subtract(
        const Duration(milliseconds: 1),
      );

  DateTime getFirstDateTimeOfTheMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month);

  DateTime getLastDateTimeOfTheMonth(DateTime dateTime) =>
      DateTime(dateTime.year, dateTime.month + 1).subtract(
        const Duration(milliseconds: 1),
      );

  bool isDateTimeFromRange({
    required DateTime date,
    required DateTime firstDateTimeOfRange,
    required DateTime lastDateTimeOfRange,
  }) {
    final bool isGreaterOrEqualToFirstDateOfRange =
        date.isAfter(firstDateTimeOfRange) ||
            date.isAtSameMomentAs(firstDateTimeOfRange);
    final bool isLowerOrEqualToLastDateOfRange =
        date.isBefore(lastDateTimeOfRange) ||
            date.isAtSameMomentAs(lastDateTimeOfRange);
    return isGreaterOrEqualToFirstDateOfRange &&
        isLowerOrEqualToLastDateOfRange;
  }
}
