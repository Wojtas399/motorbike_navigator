import 'package:injectable/injectable.dart';

@injectable
class DateService {
  DateTime getNow() => DateTime.now();

  bool isDateFromRange({
    required DateTime date,
    required DateTime firstDateOfRange,
    required DateTime lastDateOfRange,
  }) {
    final bool isGreaterOrEqualToFirstDateOfRange =
        date.isAfter(firstDateOfRange) ||
            date.isAtSameMomentAs(firstDateOfRange);
    final bool isLowerOrEqualToLastDateOfRange =
        date.isBefore(lastDateOfRange) ||
            date.isAtSameMomentAs(lastDateOfRange);
    return isGreaterOrEqualToFirstDateOfRange &&
        isLowerOrEqualToLastDateOfRange;
  }
}
