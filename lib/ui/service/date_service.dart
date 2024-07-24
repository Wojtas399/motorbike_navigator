import 'package:injectable/injectable.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();

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
