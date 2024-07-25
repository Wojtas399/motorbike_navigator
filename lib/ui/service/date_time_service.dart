import 'package:injectable/injectable.dart';

@injectable
class DateTimeService {
  DateTime getNow() => DateTime.now();

  DateTime getFirstDateTimeOfTheWeekWhichIncludesDateTime(DateTime dateTime) {
    final firstDateTimeOfTheWeek = dateTime.subtract(
      Duration(days: dateTime.weekday - 1),
    );
    return DateTime(
      firstDateTimeOfTheWeek.year,
      firstDateTimeOfTheWeek.month,
      firstDateTimeOfTheWeek.day,
    );
  }

  DateTime getLastDateTimeOfTheWeekWhichIncludedsDateTime(DateTime dateTime) {
    final lastDateTimeOfTheWeek = dateTime.add(
      Duration(days: DateTime.daysPerWeek - dateTime.weekday),
    );
    return DateTime(
      lastDateTimeOfTheWeek.year,
      lastDateTimeOfTheWeek.month,
      lastDateTimeOfTheWeek.day,
      23,
      59,
      59,
    );
  }

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
