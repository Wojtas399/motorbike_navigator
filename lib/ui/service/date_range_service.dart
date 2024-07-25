import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'date_service.dart';

@injectable
class DateRangeService {
  final DateService _dateService;

  const DateRangeService(this._dateService);

  WeeklyDateRange getWeeklyDateRange(DateTime dateTime) {
    final DateTime firstDateOfTheWeek =
        _dateService.getFirstDateOfTheWeek(dateTime);
    final DateTime lastDateOfTheWeek =
        _dateService.getLastDateOfTheWeek(dateTime);
    return WeeklyDateRange(
      firstDateOfTheWeek: firstDateOfTheWeek,
      lastDateOfTheWeek: lastDateOfTheWeek,
    );
  }

  MonthlyDateRange getMonthlyDateRange(DateTime dateTime) {
    final DateTime firstDateOfTheMonth =
        _dateService.getFirstDateOfTheMonth(dateTime);
    final DateTime lastDateOfTheMonth =
        _dateService.getLastDateOfTheMonth(dateTime);
    return MonthlyDateRange(
      firstDateOfTheMonth: firstDateOfTheMonth,
      lastDateOfTheMonth: lastDateOfTheMonth,
    );
  }

  YearlyDateRange getYearlyDateRange(DateTime dateTime) {
    final DateTime firstDateOfTheYear =
        _dateService.getFirstDateOfTheYear(dateTime);
    final DateTime lastDateOfTheYear =
        _dateService.getLastDateOfTheYear(dateTime);
    return YearlyDateRange(
      firstDateOfTheYear: firstDateOfTheYear,
      lastDateOfTheYear: lastDateOfTheYear,
    );
  }

  DateRange getPreviousRange(DateRange dateRange) => switch (dateRange) {
        WeeklyDateRange() => _getPreviousWeekRange(dateRange),
        MonthlyDateRange() => _getPreviousMonthRange(dateRange),
        YearlyDateRange() => _getPreviousYearRange(dateRange),
      };

  DateRange getNextRange(DateRange dateRange) => switch (dateRange) {
        WeeklyDateRange() => _getNextWeekRange(dateRange),
        MonthlyDateRange() => _getNextMonthRange(dateRange),
        YearlyDateRange() => _getNextYearRange(dateRange),
      };

  WeeklyDateRange _getPreviousWeekRange(WeeklyDateRange dateRange) =>
      WeeklyDateRange(
        firstDateOfTheWeek: dateRange.firstDateOfTheWeek.subtract(
          const Duration(days: 7),
        ),
        lastDateOfTheWeek: dateRange.lastDateOfTheWeek.subtract(
          const Duration(days: 7),
        ),
      );

  MonthlyDateRange _getPreviousMonthRange(MonthlyDateRange dateRange) =>
      MonthlyDateRange(
        firstDateOfTheMonth: DateTime(
          dateRange.firstDateOfTheMonth.year,
          dateRange.firstDateOfTheMonth.month - 1,
        ),
        lastDateOfTheMonth: DateTime(
          dateRange.lastDateOfTheMonth.year,
          dateRange.lastDateOfTheMonth.month,
        ).subtract(const Duration(days: 1)),
      );

  YearlyDateRange _getPreviousYearRange(YearlyDateRange dateRange) =>
      YearlyDateRange(
        firstDateOfTheYear: DateTime(dateRange.firstDateOfTheYear.year - 1),
        lastDateOfTheYear: DateTime(
          dateRange.lastDateOfTheYear.year,
        ).subtract(const Duration(days: 1)),
      );

  WeeklyDateRange _getNextWeekRange(WeeklyDateRange dateRange) =>
      WeeklyDateRange(
        firstDateOfTheWeek: dateRange.firstDateOfTheWeek.add(
          const Duration(days: 7),
        ),
        lastDateOfTheWeek: dateRange.lastDateOfTheWeek.add(
          const Duration(days: 7),
        ),
      );

  MonthlyDateRange _getNextMonthRange(MonthlyDateRange dateRange) =>
      MonthlyDateRange(
        firstDateOfTheMonth: DateTime(
          dateRange.firstDateOfTheMonth.year,
          dateRange.firstDateOfTheMonth.month + 1,
        ),
        lastDateOfTheMonth: DateTime(
          dateRange.lastDateOfTheMonth.year,
          dateRange.lastDateOfTheMonth.month + 2,
        ).subtract(const Duration(days: 1)),
      );

  YearlyDateRange _getNextYearRange(YearlyDateRange dateRange) =>
      YearlyDateRange(
        firstDateOfTheYear: DateTime(dateRange.firstDateOfTheYear.year + 1),
        lastDateOfTheYear: DateTime(
          dateRange.lastDateOfTheYear.year + 2,
        ).subtract(const Duration(days: 1)),
      );
}

sealed class DateRange extends Equatable {
  const DateRange();
}

class WeeklyDateRange extends DateRange {
  final DateTime firstDateOfTheWeek;
  final DateTime lastDateOfTheWeek;

  const WeeklyDateRange({
    required this.firstDateOfTheWeek,
    required this.lastDateOfTheWeek,
  });

  @override
  List<Object?> get props => [
        firstDateOfTheWeek,
        lastDateOfTheWeek,
      ];
}

class MonthlyDateRange extends DateRange {
  final DateTime firstDateOfTheMonth;
  final DateTime lastDateOfTheMonth;

  const MonthlyDateRange({
    required this.firstDateOfTheMonth,
    required this.lastDateOfTheMonth,
  });

  @override
  List<Object?> get props => [
        firstDateOfTheMonth,
        lastDateOfTheMonth,
      ];
}

class YearlyDateRange extends DateRange {
  final DateTime firstDateOfTheYear;
  final DateTime lastDateOfTheYear;

  const YearlyDateRange({
    required this.firstDateOfTheYear,
    required this.lastDateOfTheYear,
  });

  @override
  List<Object?> get props => [
        firstDateOfTheYear,
        lastDateOfTheYear,
      ];
}
